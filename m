Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A821B51E44
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 00:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfFXWaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 18:30:09 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36250 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726916AbfFXWaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 18:30:03 -0400
Received: by mail-pf1-f193.google.com with SMTP id r7so8316764pfl.3
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 15:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=WYJW48J6zJ4stQyWphpb9a1D44rzvcOiv36rcJxFV3A=;
        b=hWAJX1VkBgJ/G10o+8Gg/Nnq2KIpktWNwrE0CqxbTtiKgV0pthOVabdx1VdaTq/3Ea
         KWgnj2GnTX9ld/djtfgSgntDs79zP7VNzBMgRiLwZdxGJ8+K9YRKz0NRTngi514Ysq2S
         QusUiodje9asoWZaph9AhCvZwj0uEwzwZlbiV9bQvrnv3JQfV9+ifTutaVUK736n7Vw4
         oDHp/oPc7yYM8qyl69wbm4jHQQzR9EPjlhBtyk6L6kOekbD9hCkZA9TT3AvxvFr4ql2V
         V3Vj7dNGPJ9bdL17chj9U3vxiYo9J/7Qf4MFHJnFDQDJASD81BPuSxppEw8RP56KxUY/
         YgRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=WYJW48J6zJ4stQyWphpb9a1D44rzvcOiv36rcJxFV3A=;
        b=SIRueGHRi57OcZZa0q1tpV0m0ovei0jweec62Bgzpwn5g5mmRrazV1WLvpbLFell7N
         9jf1ECwMMdShaMzdGY6hPqq4rZQl0FJf2jvDCl1F2V0UbBSuyHXKGnjSKACKFzCecqUd
         kuhWHSiZfJFr4br+wgDfHxAa5GuQ4GTbKY3I8ZDz2hxjb7s1V5Lx6CuWV2qakZFr6RUq
         GoccwJSnJs0tKqjBlwxRMIIuKilfWnu28jgj32vnC3wfszaorkxOZX7HpvXpBBFwwF4S
         sa09CXTmFh6t7YXRUKck4Im7M+TbixhWSygLMuonlJnvSul/poKf2mpmuKJJo4Hx0jnC
         Z5YQ==
X-Gm-Message-State: APjAAAV9QK1AELhW0y3J5cM9reeA87CBLQphkBMB0SVboD0/mKJydg84
        xK/g9QvlO6tLfiP9oDDixJgMdlN9aDA=
X-Google-Smtp-Source: APXvYqw0agpTIs2fVvwMU/nJsHHS+DNobOQodR7fGTCqxLdLHFZVC8fTxJSQgyz3FTXdhJ1zXImpqQ==
X-Received: by 2002:a63:a342:: with SMTP id v2mr29176172pgn.403.1561415402011;
        Mon, 24 Jun 2019 15:30:02 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id p2sm16604166pfb.118.2019.06.24.15.30.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 15:30:01 -0700 (PDT)
Subject: Re: [PATCH net-next 02/18] ionic: Add hardware init and device
 commands
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org
References: <20190620202424.23215-1-snelson@pensando.io>
 <20190620202424.23215-3-snelson@pensando.io>
 <20190624135304.48755745@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <2a0789c9-03e4-4f1b-6c94-9b7a3887deae@pensando.io>
Date:   Mon, 24 Jun 2019 15:29:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190624135304.48755745@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/19 1:53 PM, Jakub Kicinski wrote:
> On Thu, 20 Jun 2019 13:24:08 -0700, Shannon Nelson wrote:
>> The ionic device has a small set of PCI registers, including a
>> device control and data space, and a large set of message
>> commands.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>>   struct ionic {
>>   	struct pci_dev *pdev;
>>   	struct device *dev;
>> +	struct ionic_dev idev;
>> +	struct mutex dev_cmd_lock;	/* lock for dev_cmd operations */
>> +	struct dentry *dentry;
>> +	struct ionic_dev_bar bars[IONIC_BARS_MAX];
>> +	unsigned int num_bars;
>> +	struct identity ident;
>> +	bool is_mgmt_nic;
> What's a management NIC?
>
>> +	ionic->is_mgmt_nic =
>> +		ent->device == PCI_DEVICE_ID_PENSANDO_IONIC_ETH_MGMT;
> You spent time in the docs describing how to use lspci, yet this magic
> NIC is not mentioned :)

I'll see what I can do to add some detail in the ionic.rst, and maybe 
add a couple hints in driver comments.

>
>>   static struct pci_driver ionic_driver = {
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
>> new file mode 100644
>> index 000000000000..e5e45e6bec9d
>> --- /dev/null
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
>> @@ -0,0 +1,239 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright(c) 2017 - 2019 Pensando Systems, Inc */
>> +
>> +#include <linux/netdevice.h>
>> +
>> +#include "ionic.h"
>> +#include "ionic_bus.h"
>> +#include "ionic_debugfs.h"
>> +
>> +#ifdef CONFIG_DEBUG_FS
>> +
>> +static int blob_open(struct inode *inode, struct file *filp)
>> +{
>> +	filp->private_data = inode->i_private;
>> +	return 0;
>> +}
>> +
>> +static ssize_t blob_read(struct file *filp, char __user *buffer,
>> +			 size_t count, loff_t *ppos)
>> +{
>> +	struct debugfs_blob_wrapper *blob = filp->private_data;
>> +
>> +	if (*ppos >= blob->size)
>> +		return 0;
>> +	if (*ppos + count > blob->size)
>> +		count = blob->size - *ppos;
>> +
>> +	if (copy_to_user(buffer, blob->data + *ppos, count))
>> +		return -EFAULT;
>> +
>> +	*ppos += count;
>> +
>> +	return count;
>> +}
>> +
>> +static ssize_t blob_write(struct file *filp, const char __user *buffer,
>> +			  size_t count, loff_t *ppos)
>> +{
>> +	struct debugfs_blob_wrapper *blob = filp->private_data;
>> +
>> +	if (*ppos >= blob->size)
>> +		return 0;
>> +	if (*ppos + count > blob->size)
>> +		count = blob->size - *ppos;
>> +
>> +	if (copy_from_user(blob->data + *ppos, buffer, count))
>> +		return -EFAULT;
>> +
>> +	*ppos += count;
>> +
>> +	return count;
>> +}
> Why would you ever have to write to a debugfs blob?  Red flag.

Yes, this obviously needs to be removed.  I won't go into the history of 
why this is here, suffice to say I didn't get everything cleaned out.

>
>> +static const struct file_operations blob_fops = {
>> +	.owner = THIS_MODULE,
>> +	.open = blob_open,
>> +	.read = blob_read,
>> +	.write = blob_write,
>> +};
>> +
>> +struct dentry *debugfs_create_blob(const char *name, umode_t mode,
>> +				   struct dentry *parent,
>> +				   struct debugfs_blob_wrapper *blob)
>> +{
>> +	return debugfs_create_file(name, mode | 0200, parent, blob,
>> +				   &blob_fops);
>> +}
>> +
>> +static struct dentry *ionic_dir;
>> +
>> +#define single(name) \
>> +static int name##_open(struct inode *inode, struct file *f)	\
>> +{								\
>> +	return single_open(f, name##_show, inode->i_private);	\
>> +}								\
>> +								\
>> +static const struct file_operations name##_fops = {		\
>> +	.owner = THIS_MODULE,					\
>> +	.open = name##_open,					\
>> +	.read = seq_read,					\
>> +	.llseek = seq_lseek,					\
>> +	.release = single_release,				\
>> +}
> DEFINE_SHOW_ATTRIBUTE() and friends.
>
>> +static int bars_show(struct seq_file *seq, void *v)
>> +{
>> +	struct ionic *ionic = seq->private;
>> +	struct ionic_dev_bar *bars = ionic->bars;
>> +	unsigned int i;
>> +
>> +	for (i = 0; i < IONIC_BARS_MAX; i++)
>> +		if (bars[i].vaddr)
>> +			seq_printf(seq, "BAR%d: len 0x%lx vaddr %pK bus_addr %pad\n",
>> +				   i, bars[i].len, bars[i].vaddr,
>> +				   &bars[i].bus_addr);
> Why? What's the value of this print beyond what's already visible from
> PCI subsystem? :S

This made debugging easier for someone

>
>> +static inline u64 encode_txq_desc_cmd(u8 opcode, u8 flags,
>> +				      u8 nsge, u64 addr)
>> +{
>> +	u64 cmd;
>> +
>> +	cmd = (opcode & IONIC_TXQ_DESC_OPCODE_MASK) << IONIC_TXQ_DESC_OPCODE_SHIFT;
> IIRC you're not a fan of the FIELD_* macros, but let me suggest them
> again :)

They don't seem to be used in the drivers from a company I used to work 
for, but that doesn't necessarily mean I'm not a fan of them. My only 
problem with them is that this particular file is an API description 
used by other OSs as well, so I'll have to see how easily we can adapt 
them into the other platforms.  I'd rather not have to duplicate all the 
macro magic for other OSs, or have one version of this file for Linux 
and a different version for other OSs.  I suspect this may be the same 
concern with that other company.

Yes, I fully understand this is not a great argument for upstream code, 
but it is a practical matter I'm juggling.

That said, I will keep an eye out for where these can be used in the 
rest of the driver.

>
>> +	cmd |= (flags & IONIC_TXQ_DESC_FLAGS_MASK) << IONIC_TXQ_DESC_FLAGS_SHIFT;
>> +	cmd |= (nsge & IONIC_TXQ_DESC_NSGE_MASK) << IONIC_TXQ_DESC_NSGE_SHIFT;
>> +	cmd |= (addr & IONIC_TXQ_DESC_ADDR_MASK) << IONIC_TXQ_DESC_ADDR_SHIFT;
>> +
>> +	return cmd;
>> +};
>> +
>> +static inline void decode_txq_desc_cmd(u64 cmd, u8 *opcode, u8 *flags,
>> +				       u8 *nsge, u64 *addr)
>> +{
>> +	*opcode = (cmd >> IONIC_TXQ_DESC_OPCODE_SHIFT) & IONIC_TXQ_DESC_OPCODE_MASK;
>> +	*flags = (cmd >> IONIC_TXQ_DESC_FLAGS_SHIFT) & IONIC_TXQ_DESC_FLAGS_MASK;
>> +	*nsge = (cmd >> IONIC_TXQ_DESC_NSGE_SHIFT) & IONIC_TXQ_DESC_NSGE_MASK;
>> +	*addr = (cmd >> IONIC_TXQ_DESC_ADDR_SHIFT) & IONIC_TXQ_DESC_ADDR_MASK;
>> +};
>> +
>> +#define IONIC_TX_MAX_SG_ELEMS	8
>> +#define IONIC_RX_MAX_SG_ELEMS	8
>> +/**
>> + * struct dev_setattr_cmd - Set Device attributes on the NIC
>> + * @opcode:     Opcode
>> + * @attr:       Attribute type (enum dev_attr)
>> + * @state:      Device state (enum dev_state)
>> + * @name:       The bus info, e.g. PCI slot-device-function, 0 terminated
> Interesting, why would this be of interest to the device?

It is useful in debugging the services inside the device.

>
>> + * @features:   Device features
>> + */
>> +struct dev_setattr_cmd {
>> +	u8     opcode;
>> +	u8     attr;
>> +	__le16 rsvd;
>> +	union {
>> +		u8      state;
>> +		char    name[IONIC_IFNAMSIZ];
>> +		__le64  features;
>> +		u8      rsvd2[60];
>> +	};
>> +};
>> +/**
>> + * struct lif_getattr_comp - LIF get attr command completion
>> + * @status:     The status of the command (enum status_code)
>> + * @comp_index: The index in the descriptor ring for which this
>> + *              is the completion.
>> + * @state:      lif state (enum lif_state)
>> + * @name:       The netdev name string, 0 terminated
>> + * @mtu:        Mtu
>> + * @mac:        Station mac
>> + * @features:   Features (enum eth_hw_features)
>> + * @color:      Color bit
>> + */
>> +struct lif_getattr_comp {
>> +	u8     status;
>> +	u8     rsvd;
>> +	__le16 comp_index;
>> +	union {
>> +		u8      state;
>> +		//char    name[IONIC_IFNAMSIZ];
> Hi!!

Oh crap.  Yes, that goes away.

Thanks for the detailed review time on a rather large file.

sln

>
>> +		__le32  mtu;
>> +		u8      mac[6];
>> +		__le64  features;
>> +		u8      rsvd2[11];
>> +	};
>> +	u8     color;
>> +};


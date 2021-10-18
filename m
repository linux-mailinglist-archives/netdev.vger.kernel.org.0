Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D054325E9
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbhJRSIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbhJRSIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 14:08:15 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5E9C06161C;
        Mon, 18 Oct 2021 11:06:03 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 75so17010339pga.3;
        Mon, 18 Oct 2021 11:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:content-transfer-encoding:cc:subject:from:to:date
         :message-id:in-reply-to;
        bh=MDZnET9wzgwL4fGoRVVyBCz2yvmPrWn7CLYkFM78kdk=;
        b=FBgERF4HEV+pCi58YkcLFzbT7bXosLTSwYqy0ntAIzUE/r21r9FLo4qe6PfpjvJqqJ
         0AZbHunwTQeqX+mqKj0cHHFZiSDpWt2sdTmgmcDEqlpRAa2H3lQqtIhE4H4LeOBpRnI+
         238ymlb+b+Upt9AIktZmbhI+qdD19fJWgI2qV+fs99pLwWkNBPJF15FfuXraR/gZU4a2
         mv6oXqfeVMY2ztZTGUyZhLUzIZS24FOLvx4/SqttZF3K8ePm+MEMTB3kWH+waEHz9r63
         gqR+jbUIwMZDDFMQ/mGnPnVEYTkUeXyQI6e7KM2vxfkWDyOi+uMQGvWViCu7xK3gXDai
         W4xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:content-transfer-encoding:cc
         :subject:from:to:date:message-id:in-reply-to;
        bh=MDZnET9wzgwL4fGoRVVyBCz2yvmPrWn7CLYkFM78kdk=;
        b=pUvvqmKVeN+OlgtqQ9oscbrLRJMDViP4cULoXvwyISRWaBvdfV5jWOIZsR9fmBO1wO
         BcKR5TnQ8cXsZvPb4ZxUS4YPBT4SyPakS+KIDmYwC8YDEX9R1JeM2vpRIS8BybssjuaW
         pAXusmeiUgoQYiSdhRtgGzbnTY4bGJNopRkgIVXtLgHe5tTlqkMncbgWNyUJHeWZ7vdC
         xyzHr+TCGWbuNbaB86IpHbUhgK+G7J6MrlMqj537WZvBuwN8ZNPFVBCUCdOeUb7tW8lA
         yb/TUz9VE1Ka6lwbaTSK6ANuink0pOZ4DETCZ1jVc1KWhQx4VNYtUCFMjaBdxYRTupbK
         eQcg==
X-Gm-Message-State: AOAM5310Ed19rCjITVfpfW7+5d/cXHT21bib8rH9TvJB4vMrdGSEzPbv
        P4DWwTcvfkFAolfAjQYbG4o=
X-Google-Smtp-Source: ABdhPJyN16z+427yH1UqxdmivqE7wnpILKH/SJkW2LdqShq9j/qRSKeaEueA6n1s2GEsP5vtUhXvPA==
X-Received: by 2002:a05:6a00:1a46:b0:44d:7a3f:2043 with SMTP id h6-20020a056a001a4600b0044d7a3f2043mr28335064pfv.56.1634580362832;
        Mon, 18 Oct 2021 11:06:02 -0700 (PDT)
Received: from localhost ([117.200.53.211])
        by smtp.gmail.com with ESMTPSA id 63sm14050784pfv.192.2021.10.18.11.05.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 11:06:02 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
Subject: Re: [RFC PATCH 09/17] net: ipa: Add support for using BAM as a DMA
 transport
From:   "Sireesh Kodali" <sireeshkodali1@gmail.com>
To:     "Alex Elder" <elder@ieee.org>, <phone-devel@vger.kernel.org>,
        <~postmarketos/upstreaming@lists.sr.ht>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <elder@kernel.org>
Date:   Mon, 18 Oct 2021 23:00:18 +0530
Message-Id: <CF2PMAWK64QJ.110OLIYYWWRIF@skynet-linux>
In-Reply-To: <794ca401-294f-54ed-0af2-e3c763723340@ieee.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu Oct 14, 2021 at 4:00 AM IST, Alex Elder wrote:
> On 9/19/21 10:08 PM, Sireesh Kodali wrote:
> > BAM is used on IPA v2.x. Since BAM already has a nice dmaengine driver,
> > the IPA driver only makes calls the dmaengine API.
> > Also add BAM transaction support to IPA's trasaction abstraction layer.
> >=20
> > BAM transactions should use NAPI just like GSI transactions, but just
> > use callbacks on each transaction for now.
>
> This is where things get a little more complicated. I'm not really
> familiar with the BAM interface and would really like to give this
> a much deeper review, and I won't be doing that now.
>
> At first glance, it looks reasonably clean to me, and it surprises
> me a little that this different system can be used with a relatively
> small amount of change. Much looks duplicated, so it could be that
> a little more work abstracting might avoid that (but I haven't looked
> that closely).
>

BAM is handled by the bam_dma driver, which supports the dmaengine API, so
all the functions are like so:

bam_function()
{
	bookkeeping();
	dmaengine_api_call();
	bookkeeping();
}

gsi_function()
{
	bookkeeping();
	gsi_register_rws();
	gsi_misc_ops();
	bookkeeping();
}

Some of the bookkeeping code is common between BAM and GSI, but the
current abstraction doesn't allow sharing that code. As I stated
previously, we might be able to share more code (or possibly all code)
between BAM and GSI if GSI was implemented as a dmaengine driver. But
reimplementing GSI like this might be rather time consuming, and there
might be easier solutions to improve code sharing between BAM and GSI.

Regards,
Sireesh

> -Alex
>
> >=20
> > Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
> > ---
> >   drivers/net/ipa/Makefile          |   2 +-
> >   drivers/net/ipa/bam.c             | 525 +++++++++++++++++++++++++++++=
+
> >   drivers/net/ipa/gsi.c             |   1 +
> >   drivers/net/ipa/ipa_data.h        |   1 +
> >   drivers/net/ipa/ipa_dma.h         |  18 +-
> >   drivers/net/ipa/ipa_dma_private.h |   2 +
> >   drivers/net/ipa/ipa_main.c        |  20 +-
> >   drivers/net/ipa/ipa_trans.c       |  14 +-
> >   drivers/net/ipa/ipa_trans.h       |   4 +
> >   9 files changed, 569 insertions(+), 18 deletions(-)
> >   create mode 100644 drivers/net/ipa/bam.c
> >=20
> > diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
> > index 3cd021fb992e..4abebc667f77 100644
> > --- a/drivers/net/ipa/Makefile
> > +++ b/drivers/net/ipa/Makefile
> > @@ -2,7 +2,7 @@ obj-$(CONFIG_QCOM_IPA)	+=3D	ipa.o
> >  =20
> >   ipa-y			:=3D	ipa_main.o ipa_power.o ipa_reg.o ipa_mem.o \
> >   				ipa_table.o ipa_interrupt.o gsi.o ipa_trans.o \
> > -				ipa_gsi.o ipa_smp2p.o ipa_uc.o \
> > +				ipa_gsi.o ipa_smp2p.o ipa_uc.o bam.o \
> >   				ipa_endpoint.o ipa_cmd.o ipa_modem.o \
> >   				ipa_resource.o ipa_qmi.o ipa_qmi_msg.o \
> >   				ipa_sysfs.o
> > diff --git a/drivers/net/ipa/bam.c b/drivers/net/ipa/bam.c
> > new file mode 100644
> > index 000000000000..0726e385fee5
> > --- /dev/null
> > +++ b/drivers/net/ipa/bam.c
> > @@ -0,0 +1,525 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +/* Copyright (c) 2020, The Linux Foundation. All rights reserved.
> > + */
> > +
> > +#include <linux/completion.h>
> > +#include <linux/dma-mapping.h>
> > +#include <linux/dmaengine.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/io.h>
> > +#include <linux/kernel.h>
> > +#include <linux/mutex.h>
> > +#include <linux/netdevice.h>
> > +#include <linux/platform_device.h>
> > +
> > +#include "ipa_gsi.h"
> > +#include "ipa.h"
> > +#include "ipa_dma.h"
> > +#include "ipa_dma_private.h"
> > +#include "ipa_gsi.h"
> > +#include "ipa_trans.h"
> > +#include "ipa_data.h"
> > +
> > +/**
> > + * DOC: The IPA Smart Peripheral System Interface
> > + *
> > + * The Smart Peripheral System is a means to communicate over BAM pipe=
s to
> > + * the IPA block. The Modem also uses BAM pipes to communicate with th=
e IPA
> > + * core.
> > + *
> > + * Refer the GSI documentation, because BAM is a precursor to GSI and =
more or less
> > + * the same, conceptually (maybe, IDK, I have no docs to go through).
> > + *
> > + * Each channel here corresponds to 1 BAM pipe configured in BAM2BAM m=
ode
> > + *
> > + * IPA cmds are transferred one at a time, each in one BAM transfer.
> > + */
> > +
> > +/* Get and configure the BAM DMA channel */
> > +int bam_channel_init_one(struct ipa_dma *bam,
> > +			 const struct ipa_gsi_endpoint_data *data, bool command)
> > +{
> > +	struct dma_slave_config bam_config;
> > +	u32 channel_id =3D data->channel_id;
> > +	struct ipa_channel *channel =3D &bam->channel[channel_id];
> > +	int ret;
> > +
> > +	/*TODO: if (!bam_channel_data_valid(bam, data))
> > +		return -EINVAL;*/
> > +
> > +	channel->dma_subsys =3D bam;
> > +	channel->dma_chan =3D dma_request_chan(bam->dev, data->channel_name);
> > +	channel->toward_ipa =3D data->toward_ipa;
> > +	channel->tlv_count =3D data->channel.tlv_count;
> > +	channel->tre_count =3D data->channel.tre_count;
> > +	if (IS_ERR(channel->dma_chan)) {
> > +		dev_err(bam->dev, "failed to request BAM channel %s: %d\n",
> > +				data->channel_name,
> > +				(int) PTR_ERR(channel->dma_chan));
> > +		return PTR_ERR(channel->dma_chan);
> > +	}
> > +
> > +	ret =3D ipa_channel_trans_init(bam, data->channel_id);
> > +	if (ret)
> > +		goto err_dma_chan_free;
> > +
> > +	if (data->toward_ipa) {
> > +		bam_config.direction =3D DMA_MEM_TO_DEV;
> > +		bam_config.dst_maxburst =3D channel->tlv_count;
> > +	} else {
> > +		bam_config.direction =3D DMA_DEV_TO_MEM;
> > +		bam_config.src_maxburst =3D channel->tlv_count;
> > +	}
> > +
> > +	dmaengine_slave_config(channel->dma_chan, &bam_config);
> > +
> > +	if (command)
> > +		ret =3D ipa_cmd_pool_init(channel, 256);
> > +
> > +	if (!ret)
> > +		return 0;
> > +
> > +err_dma_chan_free:
> > +	dma_release_channel(channel->dma_chan);
> > +	return ret;
> > +}
> > +
> > +static void bam_channel_exit_one(struct ipa_channel *channel)
> > +{
> > +	if (channel->dma_chan) {
> > +		dmaengine_terminate_sync(channel->dma_chan);
> > +		dma_release_channel(channel->dma_chan);
> > +	}
> > +}
> > +
> > +/* Get channels from BAM_DMA */
> > +int bam_channel_init(struct ipa_dma *bam, u32 count,
> > +		const struct ipa_gsi_endpoint_data *data)
> > +{
> > +	int ret =3D 0;
> > +	u32 i;
> > +
> > +	for (i =3D 0; i < count; ++i) {
> > +		bool command =3D i =3D=3D IPA_ENDPOINT_AP_COMMAND_TX;
> > +
> > +		if (!data[i].channel_name || data[i].ee_id =3D=3D GSI_EE_MODEM)
> > +			continue;
> > +
> > +		ret =3D bam_channel_init_one(bam, &data[i], command);
> > +		if (ret)
> > +			goto err_unwind;
> > +	}
> > +
> > +	return ret;
> > +
> > +err_unwind:
> > +	while (i--) {
> > +		if (ipa_gsi_endpoint_data_empty(&data[i]))
> > +			continue;
> > +
> > +		bam_channel_exit_one(&bam->channel[i]);
> > +	}
> > +	return ret;
> > +}
> > +
> > +/* Inverse of bam_channel_init() */
> > +void bam_channel_exit(struct ipa_dma *bam)
> > +{
> > +	u32 channel_id =3D BAM_CHANNEL_COUNT_MAX - 1;
> > +
> > +	do
> > +		bam_channel_exit_one(&bam->channel[channel_id]);
> > +	while (channel_id--);
> > +}
> > +
> > +/* Inverse of bam_init() */
> > +static void bam_exit(struct ipa_dma *bam)
> > +{
> > +	mutex_destroy(&bam->mutex);
> > +	bam_channel_exit(bam);
> > +}
> > +
> > +/* Return the channel id associated with a given channel */
> > +static u32 bam_channel_id(struct ipa_channel *channel)
> > +{
> > +	return channel - &channel->dma_subsys->channel[0];
> > +}
> > +
> > +static void
> > +bam_channel_tx_update(struct ipa_channel *channel, struct ipa_trans *t=
rans)
> > +{
> > +	u64 byte_count =3D trans->byte_count + trans->len;
> > +	u64 trans_count =3D trans->trans_count + 1;
> > +
> > +	byte_count -=3D channel->compl_byte_count;
> > +	channel->compl_byte_count +=3D byte_count;
> > +	trans_count -=3D channel->compl_trans_count;
> > +	channel->compl_trans_count +=3D trans_count;
> > +
> > +	ipa_gsi_channel_tx_completed(channel->dma_subsys, bam_channel_id(chan=
nel),
> > +					   trans_count, byte_count);
> > +}
> > +
> > +static void
> > +bam_channel_rx_update(struct ipa_channel *channel, struct ipa_trans *t=
rans)
> > +{
> > +	/* FIXME */
> > +	u64 byte_count =3D trans->byte_count + trans->len;
> > +
> > +	channel->byte_count +=3D byte_count;
> > +	channel->trans_count++;
> > +}
> > +
> > +/* Consult hardware, move any newly completed transactions to complete=
d list */
> > +static void bam_channel_update(struct ipa_channel *channel)
> > +{
> > +	struct ipa_trans *trans;
> > +
> > +	list_for_each_entry(trans, &channel->trans_info.pending, links) {
> > +		enum dma_status trans_status =3D
> > +				dma_async_is_tx_complete(channel->dma_chan,
> > +					trans->cookie, NULL, NULL);
> > +		if (trans_status =3D=3D DMA_COMPLETE)
> > +			break;
> > +	}
> > +	/* Get the transaction for the latest completed event.  Take a
> > +	 * reference to keep it from completing before we give the events
> > +	 * for this and previous transactions back to the hardware.
> > +	 */
> > +	refcount_inc(&trans->refcount);
> > +
> > +	/* For RX channels, update each completed transaction with the number
> > +	 * of bytes that were actually received.  For TX channels, report
> > +	 * the number of transactions and bytes this completion represents
> > +	 * up the network stack.
> > +	 */
> > +	if (channel->toward_ipa)
> > +		bam_channel_tx_update(channel, trans);
> > +	else
> > +		bam_channel_rx_update(channel, trans);
> > +
> > +	ipa_trans_move_complete(trans);
> > +
> > +	ipa_trans_free(trans);
> > +}
> > +
> > +/**
> > + * bam_channel_poll_one() - Return a single completed transaction on a=
 channel
> > + * @channel:	Channel to be polled
> > + *
> > + * Return:	Transaction pointer, or null if none are available
> > + *
> > + * This function returns the first entry on a channel's completed tran=
saction
> > + * list.  If that list is empty, the hardware is consulted to determin=
e
> > + * whether any new transactions have completed.  If so, they're moved =
to the
> > + * completed list and the new first entry is returned.  If there are n=
o more
> > + * completed transactions, a null pointer is returned.
> > + */
> > +static struct ipa_trans *bam_channel_poll_one(struct ipa_channel *chan=
nel)
> > +{
> > +	struct ipa_trans *trans;
> > +
> > +	/* Get the first transaction from the completed list */
> > +	trans =3D ipa_channel_trans_complete(channel);
> > +	if (!trans) {
> > +		bam_channel_update(channel);
> > +		trans =3D ipa_channel_trans_complete(channel);
> > +	}
> > +
> > +	if (trans)
> > +		ipa_trans_move_polled(trans);
> > +
> > +	return trans;
> > +}
> > +
> > +/**
> > + * bam_channel_poll() - NAPI poll function for a channel
> > + * @napi:	NAPI structure for the channel
> > + * @budget:	Budget supplied by NAPI core
> > + *
> > + * Return:	Number of items polled (<=3D budget)
> > + *
> > + * Single transactions completed by hardware are polled until either
> > + * the budget is exhausted, or there are no more.  Each transaction
> > + * polled is passed to ipa_trans_complete(), to perform remaining
> > + * completion processing and retire/free the transaction.
> > + */
> > +static int bam_channel_poll(struct napi_struct *napi, int budget)
> > +{
> > +	struct ipa_channel *channel;
> > +	int count =3D 0;
> > +
> > +	channel =3D container_of(napi, struct ipa_channel, napi);
> > +	while (count < budget) {
> > +		struct ipa_trans *trans;
> > +
> > +		count++;
> > +		trans =3D bam_channel_poll_one(channel);
> > +		if (!trans)
> > +			break;
> > +		ipa_trans_complete(trans);
> > +	}
> > +
> > +	if (count < budget)
> > +		napi_complete(&channel->napi);
> > +
> > +	return count;
> > +}
> > +
> > +/* Setup function for a single channel */
> > +static void bam_channel_setup_one(struct ipa_dma *bam, u32 channel_id)
> > +{
> > +	struct ipa_channel *channel =3D &bam->channel[channel_id];
> > +
> > +	if (!channel->dma_subsys)
> > +		return;	/* Ignore uninitialized channels */
> > +
> > +	if (channel->toward_ipa) {
> > +		netif_tx_napi_add(&bam->dummy_dev, &channel->napi,
> > +				  bam_channel_poll, NAPI_POLL_WEIGHT);
> > +	} else {
> > +		netif_napi_add(&bam->dummy_dev, &channel->napi,
> > +			       bam_channel_poll, NAPI_POLL_WEIGHT);
> > +	}
> > +	napi_enable(&channel->napi);
> > +}
> > +
> > +static void bam_channel_teardown_one(struct ipa_dma *bam, u32 channel_=
id)
> > +{
> > +	struct ipa_channel *channel =3D &bam->channel[channel_id];
> > +
> > +	if (!channel->dma_subsys)
> > +		return;		/* Ignore uninitialized channels */
> > +
> > +	netif_napi_del(&channel->napi);
> > +}
> > +
> > +/* Setup function for channels */
> > +static int bam_channel_setup(struct ipa_dma *bam)
> > +{
> > +	u32 channel_id =3D 0;
> > +	int ret;
> > +
> > +	mutex_lock(&bam->mutex);
> > +
> > +	do
> > +		bam_channel_setup_one(bam, channel_id);
> > +	while (++channel_id < BAM_CHANNEL_COUNT_MAX);
> > +
> > +	/* Make sure no channels were defined that hardware does not support =
*/
> > +	while (channel_id < BAM_CHANNEL_COUNT_MAX) {
> > +		struct ipa_channel *channel =3D &bam->channel[channel_id++];
> > +
> > +		if (!channel->dma_subsys)
> > +			continue;	/* Ignore uninitialized channels */
> > +
> > +		dev_err(bam->dev, "channel %u not supported by hardware\n",
> > +			channel_id - 1);
> > +		channel_id =3D BAM_CHANNEL_COUNT_MAX;
> > +		goto err_unwind;
> > +	}
> > +
> > +	mutex_unlock(&bam->mutex);
> > +
> > +	return 0;
> > +
> > +err_unwind:
> > +	while (channel_id--)
> > +		bam_channel_teardown_one(bam, channel_id);
> > +
> > +	mutex_unlock(&bam->mutex);
> > +
> > +	return ret;
> > +}
> > +
> > +/* Inverse of bam_channel_setup() */
> > +static void bam_channel_teardown(struct ipa_dma *bam)
> > +{
> > +	u32 channel_id;
> > +
> > +	mutex_lock(&bam->mutex);
> > +
> > +	channel_id =3D BAM_CHANNEL_COUNT_MAX;
> > +	do
> > +		bam_channel_teardown_one(bam, channel_id);
> > +	while (channel_id--);
> > +
> > +	mutex_unlock(&bam->mutex);
> > +}
> > +
> > +static int bam_setup(struct ipa_dma *bam)
> > +{
> > +	return bam_channel_setup(bam);
> > +}
> > +
> > +static void bam_teardown(struct ipa_dma *bam)
> > +{
> > +	bam_channel_teardown(bam);
> > +}
> > +
> > +static u32 bam_channel_tre_max(struct ipa_dma *bam, u32 channel_id)
> > +{
> > +	struct ipa_channel *channel =3D &bam->channel[channel_id];
> > +
> > +	/* Hardware limit is channel->tre_count - 1 */
> > +	return channel->tre_count - (channel->tlv_count - 1);
> > +}
> > +
> > +static u32 bam_channel_trans_tre_max(struct ipa_dma *bam, u32 channel_=
id)
> > +{
> > +	struct ipa_channel *channel =3D &bam->channel[channel_id];
> > +
> > +	return channel->tlv_count;
> > +}
> > +
> > +static int bam_channel_start(struct ipa_dma *bam, u32 channel_id)
> > +{
> > +	return 0;
> > +}
> > +
> > +static int bam_channel_stop(struct ipa_dma *bam, u32 channel_id)
> > +{
> > +	struct ipa_channel *channel =3D &bam->channel[channel_id];
> > +
> > +	return dmaengine_terminate_sync(channel->dma_chan);
> > +}
> > +
> > +static void bam_channel_reset(struct ipa_dma *bam, u32 channel_id, boo=
l doorbell)
> > +{
> > +	bam_channel_stop(bam, channel_id);
> > +}
> > +
> > +static int bam_channel_suspend(struct ipa_dma *bam, u32 channel_id)
> > +{
> > +	struct ipa_channel *channel =3D &bam->channel[channel_id];
> > +
> > +	return dmaengine_pause(channel->dma_chan);
> > +}
> > +
> > +static int bam_channel_resume(struct ipa_dma *bam, u32 channel_id)
> > +{
> > +	struct ipa_channel *channel =3D &bam->channel[channel_id];
> > +
> > +	return dmaengine_resume(channel->dma_chan);
> > +}
> > +
> > +static void bam_suspend(struct ipa_dma *bam)
> > +{
> > +	/* No-op for now */
> > +}
> > +
> > +static void bam_resume(struct ipa_dma *bam)
> > +{
> > +	/* No-op for now */
> > +}
> > +
> > +static void bam_trans_callback(void *arg)
> > +{
> > +	ipa_trans_complete(arg);
> > +}
> > +
> > +static void bam_trans_commit(struct ipa_trans *trans, bool unused)
> > +{
> > +	struct ipa_channel *channel =3D &trans->dma_subsys->channel[trans->ch=
annel_id];
> > +	enum ipa_cmd_opcode opcode =3D IPA_CMD_NONE;
> > +	struct ipa_cmd_info *info;
> > +	struct scatterlist *sg;
> > +	u32 byte_count =3D 0;
> > +	u32 i;
> > +	enum dma_transfer_direction direction;
> > +
> > +	if (channel->toward_ipa)
> > +		direction =3D DMA_MEM_TO_DEV;
> > +	else
> > +		direction =3D DMA_DEV_TO_MEM;
> > +
> > +	/* assert(trans->used > 0); */
> > +
> > +	info =3D trans->info ? &trans->info[0] : NULL;
> > +	for_each_sg(trans->sgl, sg, trans->used, i) {
> > +		bool last_tre =3D i =3D=3D trans->used - 1;
> > +		dma_addr_t addr =3D sg_dma_address(sg);
> > +		u32 len =3D sg_dma_len(sg);
> > +		u32 dma_flags =3D 0;
> > +		struct dma_async_tx_descriptor *desc;
> > +
> > +		byte_count +=3D len;
> > +		if (info)
> > +			opcode =3D info++->opcode;
> > +
> > +		if (opcode !=3D IPA_CMD_NONE) {
> > +			len =3D opcode;
> > +			dma_flags |=3D DMA_PREP_IMM_CMD;
> > +		}
> > +
> > +		if (last_tre)
> > +			dma_flags |=3D DMA_PREP_INTERRUPT;
> > +
> > +		desc =3D dmaengine_prep_slave_single(channel->dma_chan, addr, len,
> > +				direction, dma_flags);
> > +
> > +		if (last_tre) {
> > +			desc->callback =3D bam_trans_callback;
> > +			desc->callback_param =3D trans;
> > +		}
> > +
> > +		desc->cookie =3D dmaengine_submit(desc);
> > +
> > +		if (last_tre)
> > +			trans->cookie =3D desc->cookie;
> > +
> > +		if (direction =3D=3D DMA_DEV_TO_MEM)
> > +			dmaengine_desc_attach_metadata(desc, &trans->len, sizeof(trans->len=
));
> > +	}
> > +
> > +	if (channel->toward_ipa) {
> > +		/* We record TX bytes when they are sent */
> > +		trans->len =3D byte_count;
> > +		trans->trans_count =3D channel->trans_count;
> > +		trans->byte_count =3D channel->byte_count;
> > +		channel->trans_count++;
> > +		channel->byte_count +=3D byte_count;
> > +	}
> > +
> > +	ipa_trans_move_pending(trans);
> > +
> > +	dma_async_issue_pending(channel->dma_chan);
> > +}
> > +
> > +/* Initialize the BAM DMA channels
> > + * Actual hw init is handled by the BAM_DMA driver
> > + */
> > +int bam_init(struct ipa_dma *bam, struct platform_device *pdev,
> > +		enum ipa_version version, u32 count,
> > +		const struct ipa_gsi_endpoint_data *data)
> > +{
> > +	struct device *dev =3D &pdev->dev;
> > +	int ret;
> > +
> > +	bam->dev =3D dev;
> > +	bam->version =3D version;
> > +	bam->setup =3D bam_setup;
> > +	bam->teardown =3D bam_teardown;
> > +	bam->exit =3D bam_exit;
> > +	bam->suspend =3D bam_suspend;
> > +	bam->resume =3D bam_resume;
> > +	bam->channel_tre_max =3D bam_channel_tre_max;
> > +	bam->channel_trans_tre_max =3D bam_channel_trans_tre_max;
> > +	bam->channel_start =3D bam_channel_start;
> > +	bam->channel_stop =3D bam_channel_stop;
> > +	bam->channel_reset =3D bam_channel_reset;
> > +	bam->channel_suspend =3D bam_channel_suspend;
> > +	bam->channel_resume =3D bam_channel_resume;
> > +	bam->trans_commit =3D bam_trans_commit;
> > +
> > +	init_dummy_netdev(&bam->dummy_dev);
> > +
> > +	ret =3D bam_channel_init(bam, count, data);
> > +	if (ret)
> > +		return ret;
> > +
> > +	mutex_init(&bam->mutex);
> > +
> > +	return 0;
> > +}
> > diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
> > index 39d9ca620a9f..ac0b9e748fa1 100644
> > --- a/drivers/net/ipa/gsi.c
> > +++ b/drivers/net/ipa/gsi.c
> > @@ -2210,6 +2210,7 @@ int gsi_init(struct ipa_dma *gsi, struct platform=
_device *pdev,
> >   	gsi->channel_reset =3D gsi_channel_reset;
> >   	gsi->channel_suspend =3D gsi_channel_suspend;
> >   	gsi->channel_resume =3D gsi_channel_resume;
> > +	gsi->trans_commit =3D gsi_trans_commit;
> >  =20
> >   	/* GSI uses NAPI on all channels.  Create a dummy network device
> >   	 * for the channel NAPI contexts to be associated with.
> > diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
> > index 6d329e9ce5d2..7d62d49f414f 100644
> > --- a/drivers/net/ipa/ipa_data.h
> > +++ b/drivers/net/ipa/ipa_data.h
> > @@ -188,6 +188,7 @@ struct ipa_gsi_endpoint_data {
> >   	u8 channel_id;
> >   	u8 endpoint_id;
> >   	bool toward_ipa;
> > +	const char *channel_name;	/* used only for BAM DMA channels */
> >  =20
> >   	struct gsi_channel_data channel;
> >   	struct ipa_endpoint_data endpoint;
> > diff --git a/drivers/net/ipa/ipa_dma.h b/drivers/net/ipa/ipa_dma.h
> > index 1a23e6ac5785..3000182ae689 100644
> > --- a/drivers/net/ipa/ipa_dma.h
> > +++ b/drivers/net/ipa/ipa_dma.h
> > @@ -17,7 +17,11 @@
> >  =20
> >   /* Maximum number of channels and event rings supported by the driver=
 */
> >   #define GSI_CHANNEL_COUNT_MAX	23
> > +#define BAM_CHANNEL_COUNT_MAX	20
> >   #define GSI_EVT_RING_COUNT_MAX	24
> > +#define IPA_CHANNEL_COUNT_MAX	MAX(GSI_CHANNEL_COUNT_MAX, \
> > +				    BAM_CHANNEL_COUNT_MAX)
> > +#define MAX(a, b)		((a > b) ? a : b)
> >  =20
> >   /* Maximum TLV FIFO size for a channel; 64 here is arbitrary (and hig=
h) */
> >   #define GSI_TLV_MAX		64
> > @@ -119,6 +123,8 @@ struct ipa_channel {
> >   	struct gsi_ring tre_ring;
> >   	u32 evt_ring_id;
> >  =20
> > +	struct dma_chan *dma_chan;
> > +
> >   	u64 byte_count;			/* total # bytes transferred */
> >   	u64 trans_count;		/* total # transactions */
> >   	/* The following counts are used only for TX endpoints */
> > @@ -154,7 +160,7 @@ struct ipa_dma {
> >   	u32 irq;
> >   	u32 channel_count;
> >   	u32 evt_ring_count;
> > -	struct ipa_channel channel[GSI_CHANNEL_COUNT_MAX];
> > +	struct ipa_channel channel[IPA_CHANNEL_COUNT_MAX];
> >   	struct gsi_evt_ring evt_ring[GSI_EVT_RING_COUNT_MAX];
> >   	u32 event_bitmap;		/* allocated event rings */
> >   	u32 modem_channel_bitmap;	/* modem channels to allocate */
> > @@ -303,7 +309,7 @@ static inline void ipa_dma_resume(struct ipa_dma *d=
ma_subsys)
> >   }
> >  =20
> >   /**
> > - * ipa_dma_init() - Initialize the GSI subsystem
> > + * ipa_init/bam_init() - Initialize the GSI/BAM subsystem
> >    * @dma_subsys:	Address of ipa_dma structure embedded in an IPA struc=
ture
> >    * @pdev:	IPA platform device
> >    * @version:	IPA hardware version (implies GSI version)
> > @@ -312,14 +318,18 @@ static inline void ipa_dma_resume(struct ipa_dma =
*dma_subsys)
> >    *
> >    * Return:	0 if successful, or a negative error code
> >    *
> > - * Early stage initialization of the GSI subsystem, performing tasks
> > - * that can be done before the GSI hardware is ready to use.
> > + * Early stage initialization of the GSI/BAM subsystem, performing tas=
ks
> > + * that can be done before the GSI/BAM hardware is ready to use.
> >    */
> >  =20
> >   int gsi_init(struct ipa_dma *dma_subsys, struct platform_device *pdev=
,
> >   	     enum ipa_version version, u32 count,
> >   	     const struct ipa_gsi_endpoint_data *data);
> >  =20
> > +int bam_init(struct ipa_dma *dma_subsys, struct platform_device *pdev,
> > +	     enum ipa_version version, u32 count,
> > +	     const struct ipa_gsi_endpoint_data *data);
> > +
> >   /**
> >    * ipa_dma_exit() - Exit the DMA subsystem
> >    * @dma_subsys:	ipa_dma address previously passed to a successful gsi=
_init() call
> > diff --git a/drivers/net/ipa/ipa_dma_private.h b/drivers/net/ipa/ipa_dm=
a_private.h
> > index 40148a551b47..1db53e597a61 100644
> > --- a/drivers/net/ipa/ipa_dma_private.h
> > +++ b/drivers/net/ipa/ipa_dma_private.h
> > @@ -16,6 +16,8 @@ struct ipa_channel;
> >  =20
> >   #define GSI_RING_ELEMENT_SIZE	16	/* bytes; must be a power of 2 */
> >  =20
> > +void gsi_trans_commit(struct ipa_trans *trans, bool ring_db);
> > +
> >   /* Return the entry that follows one provided in a transaction pool *=
/
> >   void *ipa_trans_pool_next(struct ipa_trans_pool *pool, void *element)=
;
> >  =20
> > diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
> > index ba06e3ad554c..ea6c4347f2c6 100644
> > --- a/drivers/net/ipa/ipa_main.c
> > +++ b/drivers/net/ipa/ipa_main.c
> > @@ -60,12 +60,15 @@
> >    * core.  The GSI implements a set of "channels" used for communicati=
on
> >    * between the AP and the IPA.
> >    *
> > - * The IPA layer uses GSI channels to implement its "endpoints".  And =
while
> > - * a GSI channel carries data between the AP and the IPA, a pair of IP=
A
> > - * endpoints is used to carry traffic between two EEs.  Specifically, =
the main
> > - * modem network interface is implemented by two pairs of endpoints:  =
a TX
> > + * The IPA layer uses GSI channels or BAM pipes to implement its "endp=
oints".
> > + * And while a GSI channel carries data between the AP and the IPA, a =
pair of
> > + * IPA endpoints is used to carry traffic between two EEs.  Specifical=
ly, the
> > + * main modem network interface is implemented by two pairs of endpoin=
ts:  a TX
> >    * endpoint on the AP coupled with an RX endpoint on the modem; and a=
nother
> >    * RX endpoint on the AP receiving data from a TX endpoint on the mod=
em.
> > + *
> > + * For BAM based transport, a pair of BAM pipes are used for TX and RX=
 between
> > + * the AP and IPA, and between IPA and other EEs.
> >    */
> >  =20
> >   /* The name of the GSI firmware file relative to /lib/firmware */
> > @@ -716,8 +719,13 @@ static int ipa_probe(struct platform_device *pdev)
> >   	if (ret)
> >   		goto err_reg_exit;
> >  =20
> > -	ret =3D gsi_init(&ipa->dma_subsys, pdev, ipa->version, data->endpoint=
_count,
> > -		       data->endpoint_data);
> > +	if (IPA_HAS_GSI(ipa->version))
> > +		ret =3D gsi_init(&ipa->dma_subsys, pdev, ipa->version, data->endpoin=
t_count,
> > +			       data->endpoint_data);
> > +	else
> > +		ret =3D bam_init(&ipa->dma_subsys, pdev, ipa->version, data->endpoin=
t_count,
> > +			       data->endpoint_data);
> > +
> >   	if (ret)
> >   		goto err_mem_exit;
> >  =20
> > diff --git a/drivers/net/ipa/ipa_trans.c b/drivers/net/ipa/ipa_trans.c
> > index 22755f3ce3da..444f44846da8 100644
> > --- a/drivers/net/ipa/ipa_trans.c
> > +++ b/drivers/net/ipa/ipa_trans.c
> > @@ -254,7 +254,7 @@ struct ipa_trans *ipa_channel_trans_complete(struct=
 ipa_channel *channel)
> >   }
> >  =20
> >   /* Move a transaction from the allocated list to the pending list */
> > -static void ipa_trans_move_pending(struct ipa_trans *trans)
> > +void ipa_trans_move_pending(struct ipa_trans *trans)
> >   {
> >   	struct ipa_channel *channel =3D &trans->dma_subsys->channel[trans->c=
hannel_id];
> >   	struct ipa_trans_info *trans_info =3D &channel->trans_info;
> > @@ -539,7 +539,7 @@ static void gsi_trans_tre_fill(struct gsi_tre *dest=
_tre, dma_addr_t addr,
> >    * pending list.  Finally, updates the channel ring pointer and optio=
nally
> >    * rings the doorbell.
> >    */
> > -static void __gsi_trans_commit(struct ipa_trans *trans, bool ring_db)
> > +void gsi_trans_commit(struct ipa_trans *trans, bool ring_db)
> >   {
> >   	struct ipa_channel *channel =3D &trans->dma_subsys->channel[trans->c=
hannel_id];
> >   	struct gsi_ring *ring =3D &channel->tre_ring;
> > @@ -604,9 +604,9 @@ static void __gsi_trans_commit(struct ipa_trans *tr=
ans, bool ring_db)
> >   /* Commit a GSI transaction */
> >   void ipa_trans_commit(struct ipa_trans *trans, bool ring_db)
> >   {
> > -	if (trans->used)
> > -		__gsi_trans_commit(trans, ring_db);
> > -	else
> > +	if (trans->used) {
> > +		trans->dma_subsys->trans_commit(trans, ring_db);
> > +	} else
> >   		ipa_trans_free(trans);
> >   }
> >  =20
> > @@ -618,7 +618,7 @@ void ipa_trans_commit_wait(struct ipa_trans *trans)
> >  =20
> >   	refcount_inc(&trans->refcount);
> >  =20
> > -	__gsi_trans_commit(trans, true);
> > +	trans->dma_subsys->trans_commit(trans, true);
> >  =20
> >   	wait_for_completion(&trans->completion);
> >  =20
> > @@ -638,7 +638,7 @@ int ipa_trans_commit_wait_timeout(struct ipa_trans =
*trans,
> >  =20
> >   	refcount_inc(&trans->refcount);
> >  =20
> > -	__gsi_trans_commit(trans, true);
> > +	trans->dma_subsys->trans_commit(trans, true);
> >  =20
> >   	remaining =3D wait_for_completion_timeout(&trans->completion,
> >   						timeout_jiffies);
> > diff --git a/drivers/net/ipa/ipa_trans.h b/drivers/net/ipa/ipa_trans.h
> > index b93342414360..5f41e3e6f92a 100644
> > --- a/drivers/net/ipa/ipa_trans.h
> > +++ b/drivers/net/ipa/ipa_trans.h
> > @@ -10,6 +10,7 @@
> >   #include <linux/refcount.h>
> >   #include <linux/completion.h>
> >   #include <linux/dma-direction.h>
> > +#include <linux/dmaengine.h>
> >  =20
> >   #include "ipa_cmd.h"
> >  =20
> > @@ -61,6 +62,7 @@ struct ipa_trans {
> >   	struct scatterlist *sgl;
> >   	struct ipa_cmd_info *info;	/* array of entries, or null */
> >   	enum dma_data_direction direction;
> > +	dma_cookie_t cookie;
> >  =20
> >   	refcount_t refcount;
> >   	struct completion completion;
> > @@ -149,6 +151,8 @@ struct ipa_trans *ipa_channel_trans_alloc(struct ip=
a_dma *dma_subsys, u32 channe
> >    */
> >   void ipa_trans_free(struct ipa_trans *trans);
> >  =20
> > +void ipa_trans_move_pending(struct ipa_trans *trans);
> > +
> >   /**
> >    * ipa_trans_cmd_add() - Add an immediate command to a transaction
> >    * @trans:	Transaction
> >=20


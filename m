Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DAD235091
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 07:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgHAFN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 01:13:27 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:17710 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbgHAFN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 01:13:26 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596258805; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: Date: Subject: In-Reply-To: References: Cc:
 To: From: Sender; bh=T9e/VPqBxWYcAm2kaYv+wudjT7WIZcDPMhOlmtz3PkU=; b=cqoUynVX3ElP80hKc0pC5xOR1kK+2d2uKuZ0mFdLWhuZuUHI7gNk3Zk5rlR7GaidpFQQDf6w
 /7ouU2QEeJG2zmgmGbsOy/tg2rLZIIT4zsZAHiqCn8cV6x2qa11wxqTRDzbdeFed32Cchxzs
 boz+4id1ILIFCeNzi5MYSLJfEuk=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n18.prod.us-west-2.postgun.com with SMTP id
 5f24f9f40825c301ea5b0326 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 01 Aug 2020 05:13:24
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9A495C433CB; Sat,  1 Aug 2020 05:13:24 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from Pillair (unknown [49.205.240.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 92B24C433C6;
        Sat,  1 Aug 2020 05:13:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 92B24C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   "Rakesh Pillai" <pillair@codeaurora.org>
To:     "'Ben Greear'" <greearb@candelatech.com>,
        <ath10k@lists.infradead.org>
Cc:     <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>
References: <1596220042-2778-1-git-send-email-pillair@codeaurora.org> <1596220042-2778-2-git-send-email-pillair@codeaurora.org> <bedc5fe0-1904-d045-4a84-0869ee1b0b2e@candelatech.com>
In-Reply-To: <bedc5fe0-1904-d045-4a84-0869ee1b0b2e@candelatech.com>
Subject: RE: [PATCH v2 1/3] ath10k: Add history for tracking certain events
Date:   Sat, 1 Aug 2020 10:43:16 +0530
Message-ID: <000901d667c2$7a645380$6f2cfa80$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQG33jQ4R3ZVYFu9l+A0slgX59AuwQGE2nscAdPRV4mpRQJXIA==
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Ben Greear <greearb@candelatech.com>
> Sent: Saturday, August 1, 2020 12:08 AM
> To: Rakesh Pillai <pillair@codeaurora.org>; ath10k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org; linux-kernel@vger.kernel.org;
> kvalo@codeaurora.org; davem@davemloft.net; kuba@kernel.org;
> netdev@vger.kernel.org
> Subject: Re: [PATCH v2 1/3] ath10k: Add history for tracking certain =
events
>=20
> On 7/31/20 11:27 AM, Rakesh Pillai wrote:
> > Add history for tracking the below events
> > - register read
> > - register write
> > - IRQ trigger
> > - NAPI poll
> > - CE service
> > - WMI cmd
> > - WMI event
> > - WMI tx completion
> >
> > This will help in debugging any crash or any
> > improper behaviour.
> >
> > Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1
> >
> > Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> > ---
> >   drivers/net/wireless/ath/ath10k/ce.c      |   1 +
> >   drivers/net/wireless/ath/ath10k/core.h    |  74 +++++++++++++++++
> >   drivers/net/wireless/ath/ath10k/debug.c   | 133
> ++++++++++++++++++++++++++++++
> >   drivers/net/wireless/ath/ath10k/debug.h   |  74 +++++++++++++++++
> >   drivers/net/wireless/ath/ath10k/snoc.c    |  15 +++-
> >   drivers/net/wireless/ath/ath10k/wmi-tlv.c |   1 +
> >   drivers/net/wireless/ath/ath10k/wmi.c     |  10 +++
> >   7 files changed, 307 insertions(+), 1 deletion(-)
> >
>=20
> > +void ath10k_record_wmi_event(struct ath10k *ar, enum
> ath10k_wmi_type type,
> > +			     u32 id, unsigned char *data)
> > +{
> > +	struct ath10k_wmi_event_entry *entry;
> > +	u32 idx;
> > +
> > +	if (type =3D=3D ATH10K_WMI_EVENT) {
> > +		if (!ar->wmi_event_history.record)
> > +			return;
>=20
> This check above is duplicated below, add it once at top of the method
> instead.

The same function is used to record WMI events and CMD, which are stored =
in different memory locations.
Hence the check  " if (type =3D=3D ATH10K_WMI_EVENT) {" is necessary.


>=20
> > +
> > +		spin_lock_bh(&ar->wmi_event_history.hist_lock);
> > +		idx =3D ath10k_core_get_next_idx(&ar-
> >reg_access_history.index,
> > +					       ar-
> >wmi_event_history.max_entries);
> > +		spin_unlock_bh(&ar->wmi_event_history.hist_lock);
> > +		entry =3D &ar->wmi_event_history.record[idx];
> > +	} else {
> > +		if (!ar->wmi_cmd_history.record)
> > +			return;
> > +
> > +		spin_lock_bh(&ar->wmi_cmd_history.hist_lock);
> > +		idx =3D ath10k_core_get_next_idx(&ar-
> >reg_access_history.index,
> > +					       ar-
> >wmi_cmd_history.max_entries);
> > +		spin_unlock_bh(&ar->wmi_cmd_history.hist_lock);
> > +		entry =3D &ar->wmi_cmd_history.record[idx];
> > +	}
> > +
> > +	entry->timestamp =3D ath10k_core_get_timestamp();
> > +	entry->cpu_id =3D smp_processor_id();
> > +	entry->type =3D type;
> > +	entry->id =3D id;
> > +	memcpy(&entry->data, data + 4, ATH10K_WMI_DATA_LEN);
> > +}
> > +EXPORT_SYMBOL(ath10k_record_wmi_event);
>=20
> > @@ -1660,6 +1668,11 @@ static int ath10k_snoc_probe(struct
> platform_device *pdev)
> >   	ar->ce_priv =3D &ar_snoc->ce;
> >   	msa_size =3D drv_data->msa_size;
> >
> > +	ath10k_core_reg_access_history_init(ar,
> ATH10K_REG_ACCESS_HISTORY_MAX);
> > +	ath10k_core_wmi_event_history_init(ar,
> ATH10K_WMI_EVENT_HISTORY_MAX);
> > +	ath10k_core_wmi_cmd_history_init(ar,
> ATH10K_WMI_CMD_HISTORY_MAX);
> > +	ath10k_core_ce_event_history_init(ar,
> ATH10K_CE_EVENT_HISTORY_MAX);
>=20
> Maybe only enable this once user turns it on?  It sucks up a bit of =
memory?


This memory will be allocated only if the history is enabled via module =
param, else the function just returns 0.


>=20
> > +
> >   	ath10k_snoc_quirks_init(ar);
> >
> >   	ret =3D ath10k_snoc_resource_init(ar);
> > diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
> b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
> > index 932266d..9df5748 100644
> > --- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
> > +++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
> > @@ -627,6 +627,7 @@ static void ath10k_wmi_tlv_op_rx(struct ath10k =
*ar,
> struct sk_buff *skb)
> >   	if (skb_pull(skb, sizeof(struct wmi_cmd_hdr)) =3D=3D NULL)
> >   		goto out;
> >
> > +	ath10k_record_wmi_event(ar, ATH10K_WMI_EVENT, id, skb->data);
> >   	trace_ath10k_wmi_event(ar, id, skb->data, skb->len);
> >
> >   	consumed =3D ath10k_tm_event_wmi(ar, id, skb);
> > diff --git a/drivers/net/wireless/ath/ath10k/wmi.c
> b/drivers/net/wireless/ath/ath10k/wmi.c
> > index a81a1ab..8ebd05c 100644
> > --- a/drivers/net/wireless/ath/ath10k/wmi.c
> > +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> > @@ -1802,6 +1802,15 @@ struct sk_buff *ath10k_wmi_alloc_skb(struct
> ath10k *ar, u32 len)
> >
> >   static void ath10k_wmi_htc_tx_complete(struct ath10k *ar, struct =
sk_buff
> *skb)
> >   {
> > +	struct wmi_cmd_hdr *cmd_hdr;
> > +	enum wmi_tlv_event_id id;
> > +
> > +	cmd_hdr =3D (struct wmi_cmd_hdr *)skb->data;
> > +	id =3D MS(__le32_to_cpu(cmd_hdr->cmd_id),
> WMI_CMD_HDR_CMD_ID);
> > +
> > +	ath10k_record_wmi_event(ar, ATH10K_WMI_TX_COMPL, id,
> > +				skb->data + sizeof(struct wmi_cmd_hdr));
> > +
> >   	dev_kfree_skb(skb);
> >   }
>=20
> I think guard the above new code with if (unlikely(ar-
> >ce_event_history.record)) { ... }
>=20
> All in all, I think I'd want to compile this out (while leaving other =
debug
> compiled
> in) since it seems this stuff would be rarely used and it adds method =
calls to
> hot
> paths.
>=20
> That is a decision for Kalle though, so see what he says...


Sure let me add this check.


>=20
> Thanks,
> Ben
>=20
>=20
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com


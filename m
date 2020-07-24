Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26D322BE03
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 08:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgGXGUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 02:20:12 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:22065 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726493AbgGXGUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 02:20:12 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595571610; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: Date: Subject: In-Reply-To: References: Cc:
 To: From: Sender; bh=paVXKsmzeg5/qxSudmtRIQ5uq5kOrJ80jzH+Ujzi6Vw=; b=Ur/4Inws28V9UJ5Xs/4AnEoVXnNBN9WIOMgGuv3MD4jxH4hA/X1Rc7jZ2WBwc7yFKsKZzcOg
 3uj3coo6JeKM7jEc5UMl9gZhZFRBockOTI0RqpcH+/vt4mFxjMSsh4noyLNJua6I0PXYJg3h
 dVU7ixRdBKHpRoU0CtzjzcUqcIU=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n11.prod.us-east-1.postgun.com with SMTP id
 5f1a7d8af9ca681bd08ec4ce (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 24 Jul 2020 06:19:54
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7F31BC433CA; Fri, 24 Jul 2020 06:19:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from Pillair (unknown [183.83.71.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: pillair)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0CAE1C433C6;
        Fri, 24 Jul 2020 06:19:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0CAE1C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   "Rakesh Pillai" <pillair@codeaurora.org>
To:     "'Sebastian Gottschall'" <s.gottschall@dd-wrt.com>,
        <ath10k@lists.infradead.org>
Cc:     <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvalo@codeaurora.org>, <johannes@sipsolutions.net>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <dianders@chromium.org>, <evgreen@chromium.org>
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org> <1595351666-28193-8-git-send-email-pillair@codeaurora.org> <1540605b-c54e-d482-296f-8139eb07c195@dd-wrt.com>
In-Reply-To: <1540605b-c54e-d482-296f-8139eb07c195@dd-wrt.com>
Subject: RE: [RFC 7/7] ath10k: Handle rx thread suspend and resume
Date:   Fri, 24 Jul 2020 11:49:46 +0530
Message-ID: <000001d66182$70d2bc30$52783490$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQG1Bu1FBYi7G1oVhHY/01uT1gSslwGYY6AwAmphXtGpOOBtAA==
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
> Sent: Friday, July 24, 2020 4:36 AM
> To: Rakesh Pillai <pillair@codeaurora.org>; ath10k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org; linux-kernel@vger.kernel.org;
> kvalo@codeaurora.org; johannes@sipsolutions.net; davem@davemloft.net;
> kuba@kernel.org; netdev@vger.kernel.org; dianders@chromium.org;
> evgreen@chromium.org
> Subject: Re: [RFC 7/7] ath10k: Handle rx thread suspend and resume
>=20
> your patch seem to only affect the WCN3990 chipset. all other ath10k
> supported chipset are not supported here. so you see a chance to
> implement this more generic?
>=20
> Sebastian

Hi Sebastian,

A generic core for handling threads is added with this patchset.
So the handling of rx packet processing in thread can always be extended =
to other targets, if they wish so.

The thread related APIs are in core.c which gives all the other targets =
access to these APIs for using them.

Thanks,
Rakesh Pillai.

>=20
> Am 21.07.2020 um 19:14 schrieb Rakesh Pillai:
> > During the system suspend or resume, the rx thread
> > also needs to be suspended or resume respectively.
> >
> > Handle the rx thread as well during the system
> > suspend and resume.
> >
> > Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1
> >
> > Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> > ---
> >   drivers/net/wireless/ath/ath10k/core.c | 23 ++++++++++++++++++
> >   drivers/net/wireless/ath/ath10k/core.h |  5 ++++
> >   drivers/net/wireless/ath/ath10k/snoc.c | 44
> +++++++++++++++++++++++++++++++++-
> >   3 files changed, 71 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/core.c
> b/drivers/net/wireless/ath/ath10k/core.c
> > index 4064fa2..b82b355 100644
> > --- a/drivers/net/wireless/ath/ath10k/core.c
> > +++ b/drivers/net/wireless/ath/ath10k/core.c
> > @@ -668,6 +668,27 @@ static unsigned int
> ath10k_core_get_fw_feature_str(char *buf,
> >   	return scnprintf(buf, buf_len, "%s",
> ath10k_core_fw_feature_str[feat]);
> >   }
> >
> > +int ath10k_core_thread_suspend(struct ath10k_thread *thread)
> > +{
> > +	ath10k_dbg(thread->ar, ATH10K_DBG_BOOT, "Suspending thread
> %s\n",
> > +		   thread->name);
> > +	set_bit(ATH10K_THREAD_EVENT_SUSPEND, thread->event_flags);
> > +	wait_for_completion(&thread->suspend);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(ath10k_core_thread_suspend);
> > +
> > +int ath10k_core_thread_resume(struct ath10k_thread *thread)
> > +{
> > +	ath10k_dbg(thread->ar, ATH10K_DBG_BOOT, "Resuming thread
> %s\n",
> > +		   thread->name);
> > +	complete(&thread->resume);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(ath10k_core_thread_resume);
> > +
> >   void ath10k_core_thread_post_event(struct ath10k_thread *thread,
> >   				   enum ath10k_thread_events event)
> >   {
> > @@ -700,6 +721,8 @@ int ath10k_core_thread_init(struct ath10k *ar,
> >
> >   	init_waitqueue_head(&thread->wait_q);
> >   	init_completion(&thread->shutdown);
> > +	init_completion(&thread->suspend);
> > +	init_completion(&thread->resume);
> >   	memcpy(thread->name, thread_name,
> ATH10K_THREAD_NAME_SIZE_MAX);
> >   	clear_bit(ATH10K_THREAD_EVENT_SHUTDOWN, thread-
> >event_flags);
> >   	ath10k_info(ar, "Starting thread %s\n", thread_name);
> > diff --git a/drivers/net/wireless/ath/ath10k/core.h
> b/drivers/net/wireless/ath/ath10k/core.h
> > index 596d31b..df65e75 100644
> > --- a/drivers/net/wireless/ath/ath10k/core.h
> > +++ b/drivers/net/wireless/ath/ath10k/core.h
> > @@ -976,6 +976,7 @@ enum ath10k_thread_events {
> >   	ATH10K_THREAD_EVENT_SHUTDOWN,
> >   	ATH10K_THREAD_EVENT_RX_POST,
> >   	ATH10K_THREAD_EVENT_TX_POST,
> > +	ATH10K_THREAD_EVENT_SUSPEND,
> >   	ATH10K_THREAD_EVENT_MAX,
> >   };
> >
> > @@ -983,6 +984,8 @@ struct ath10k_thread {
> >   	struct ath10k *ar;
> >   	struct task_struct *task;
> >   	struct completion shutdown;
> > +	struct completion suspend;
> > +	struct completion resume;
> >   	wait_queue_head_t wait_q;
> >   	DECLARE_BITMAP(event_flags, ATH10K_THREAD_EVENT_MAX);
> >   	char name[ATH10K_THREAD_NAME_SIZE_MAX];
> > @@ -1296,6 +1299,8 @@ static inline bool
> ath10k_peer_stats_enabled(struct ath10k *ar)
> >
> >   extern unsigned long ath10k_coredump_mask;
> >
> > +int ath10k_core_thread_suspend(struct ath10k_thread *thread);
> > +int ath10k_core_thread_resume(struct ath10k_thread *thread);
> >   void ath10k_core_thread_post_event(struct ath10k_thread *thread,
> >   				   enum ath10k_thread_events event);
> >   int ath10k_core_thread_shutdown(struct ath10k *ar,
> > diff --git a/drivers/net/wireless/ath/ath10k/snoc.c
> b/drivers/net/wireless/ath/ath10k/snoc.c
> > index 3eb5eac..a373b2b 100644
> > --- a/drivers/net/wireless/ath/ath10k/snoc.c
> > +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> > @@ -932,13 +932,31 @@ int ath10k_snoc_rx_thread_loop(void *data)
> >   					    rx_thread->event_flags) ||
> >
> test_and_clear_bit(ATH10K_THREAD_EVENT_TX_POST,
> >   					    rx_thread->event_flags) ||
> > +			 test_bit(ATH10K_THREAD_EVENT_SUSPEND,
> > +				  rx_thread->event_flags) ||
> >   			 test_bit(ATH10K_THREAD_EVENT_SHUTDOWN,
> >   				  rx_thread->event_flags)));
> >
> > +		if (test_and_clear_bit(ATH10K_THREAD_EVENT_SUSPEND,
> > +				       rx_thread->event_flags)) {
> > +			complete(&rx_thread->suspend);
> > +			ath10k_info(ar, "rx thread suspend\n");
> > +			wait_for_completion(&rx_thread->resume);
> > +			ath10k_info(ar, "rx thread resume\n");
> > +		}
> > +
> >   		ath10k_htt_txrx_compl_task(ar, thread_budget);
> >   		if
> (test_and_clear_bit(ATH10K_THREAD_EVENT_SHUTDOWN,
> >   				       rx_thread->event_flags))
> >   			shutdown =3D true;
> > +
> > +		if (test_and_clear_bit(ATH10K_THREAD_EVENT_SUSPEND,
> > +				       rx_thread->event_flags)) {
> > +			complete(&rx_thread->suspend);
> > +			ath10k_info(ar, "rx thread suspend\n");
> > +			wait_for_completion(&rx_thread->resume);
> > +			ath10k_info(ar, "rx thread resume\n");
> > +		}
> >   	}
> >
> >   	ath10k_dbg(ar, ATH10K_DBG_SNOC, "rx thread exiting\n");
> > @@ -1133,15 +1151,30 @@ static int ath10k_snoc_hif_suspend(struct
> ath10k *ar)
> >   	if (!device_may_wakeup(ar->dev))
> >   		return -EPERM;
> >
> > +	if (ar->rx_thread_enable) {
> > +		ret =3D ath10k_core_thread_suspend(&ar->rx_thread);
> > +		if (ret) {
> > +			ath10k_err(ar, "failed to suspend rx_thread, %d\n",
> > +				   ret);
> > +			return ret;
> > +		}
> > +	}
> > +
> >   	ret =3D enable_irq_wake(ar_snoc-
> >ce_irqs[ATH10K_SNOC_WAKE_IRQ].irq_line);
> >   	if (ret) {
> >   		ath10k_err(ar, "failed to enable wakeup irq :%d\n", ret);
> > -		return ret;
> > +		goto fail;
> >   	}
> >
> >   	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc device suspended\n");
> >
> >   	return ret;
> > +
> > +fail:
> > +	if (ar->rx_thread_enable)
> > +		ath10k_core_thread_resume(&ar->rx_thread);
> > +
> > +	return ret;
> >   }
> >
> >   static int ath10k_snoc_hif_resume(struct ath10k *ar)
> > @@ -1158,6 +1191,15 @@ static int ath10k_snoc_hif_resume(struct =
ath10k
> *ar)
> >   		return ret;
> >   	}
> >
> > +	if (ar->rx_thread_enable) {
> > +		ret =3D ath10k_core_thread_resume(&ar->rx_thread);
> > +		if (ret) {
> > +			ath10k_err(ar, "failed to suspend rx_thread, %d\n",
> > +				   ret);
> > +			return ret;
> > +		}
> > +	}
> > +
> >   	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc device resumed\n");
> >
> >   	return ret;


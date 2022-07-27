Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87B7C581E74
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 05:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbiG0D4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 23:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240174AbiG0D4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 23:56:35 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853F32191
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 20:56:33 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id o12so14995156pfp.5
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 20:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=26dgfwDJV1YdSH3yRiynKtDCTrAjWeNhFDWsvG4I5qk=;
        b=Su1eZeHdt+dVnIAZ7A9gSFjJuA4tuU37lsxK7ftlkzDHmZfoN9WAtwdS9BCoVduH43
         V175y30CyFVOINYQEUvrP79SagECIpGmh05p4LDhLnqLfVQ0C9mo2k9P7nzDGbU4fYhL
         wjiQK7mkPPXZVVbn+Ysq4ODX9ib++PeHN+gaAf6L/k8ibWVDOeHAffpdeubNGwKH+jgi
         /aoCWwJRjG5O2hBI4oPna3mGlf6orDIWuf7RkMYjiWTsXCBRitebTm0rz5jUQ+kO+A89
         jDb+8IluRMPPtPDl8DqKw1Eqqe21OLjILXeYatZvrId7iUkoGi5LScIGYlsCdNUFubkz
         LhTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=26dgfwDJV1YdSH3yRiynKtDCTrAjWeNhFDWsvG4I5qk=;
        b=aXWEVkC+6572J3q0mpmJ2B3CWHSfrrJPqCQ79vWbFGubAB9QLxNbm17CR+WUb95fPW
         wYsJHET10nGAvnCVJB1HY29MomiDEbAsJ2Wy8w2W9j4e6JgLC1jmdX5m+r3SpIDtva/1
         6W874yqMddRkSeavfeeQuE903tjZ9Mh07ODGsdd5/cg7+2X65fHh8qTNkINP10K2TiYe
         jW2SZMgIrhFy2zt9y4+wzZp6WP7mezyYzoRbcFP0VNAgBXqjs9hc/zGQjm23wan0EaZn
         geCxk+d9vrVTBw1CNaHkG1lHNl3/Tylald8RGGtA09FMIGf9ssCu/w6VQxkDWAEUuFD/
         2FDA==
X-Gm-Message-State: AJIora93W1zgEj7RV6foeH/jwACaqPIOFrGuZtX60iL3GTMY87zg+APP
        8GwmGOeedlhywmI0PrYCtgs=
X-Google-Smtp-Source: AGRyM1s+Zg6jnjbSUxXZ6DrKwl83E4PXRozz+WEKlctiFoaJ7o8+s4ecpxTYR59nv+5oL72naCnbNQ==
X-Received: by 2002:a62:79d7:0:b0:52a:b557:2796 with SMTP id u206-20020a6279d7000000b0052ab5572796mr19704701pfc.34.1658894192848;
        Tue, 26 Jul 2022 20:56:32 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id cp1-20020a170902e78100b0016d2540c098sm12344435plb.231.2022.07.26.20.56.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 20:56:32 -0700 (PDT)
Message-ID: <1fba23a6-746f-0ccd-a8ce-2633a55df90b@gmail.com>
Date:   Wed, 27 Jul 2022 12:56:28 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 net] sfc: disable softirqs for ptp TX
Content-Language: en-US
To:     alejandro.lucero-palau@amd.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, linux-net-drivers@amd.com
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, edumazet@google.com, fw@strlen.de
References: <20220726064504.49613-1-alejandro.lucero-palau@amd.com>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <20220726064504.49613-1-alejandro.lucero-palau@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alejandro Lucero,

On 7/26/22 15:45, alejandro.lucero-palau@amd.com wrote:
 > From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
 >
 > Sending a PTP packet can imply to use the normal TX driver datapath but
 > invoked from the driver's ptp worker. The kernel generic TX code
 > disables softirqs and preemption before calling specific driver TX code,
 > but the ptp worker does not. Although current ptp driver functionality
 > does not require it, there are several reasons for doing so:
 >
 >     1) The invoked code is always executed with softirqs disabled for non
 >        PTP packets.
 >     2) Better if a ptp packet transmission is not interrupted by softirq
 >        handling which could lead to high latencies.
 >     3) netdev_xmit_more used by the TX code requires preemption to be
 >        disabled.
 >
 > Indeed a solution for dealing with kernel preemption state based on 
static
 > kernel configuration is not possible since the introduction of dynamic
 > preemption level configuration at boot time using the static calls
 > functionality.
 >
 > Fixes: f79c957a0b537 ("drivers: net: sfc: use netdev_xmit_more helper")
 > Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
 > ---
 >   drivers/net/ethernet/sfc/ptp.c | 22 ++++++++++++++++++++++
 >   1 file changed, 22 insertions(+)
 >
 > diff --git a/drivers/net/ethernet/sfc/ptp.c 
b/drivers/net/ethernet/sfc/ptp.c
 > index 4625f85acab2..10ad0b93d283 100644
 > --- a/drivers/net/ethernet/sfc/ptp.c
 > +++ b/drivers/net/ethernet/sfc/ptp.c
 > @@ -1100,7 +1100,29 @@ static void efx_ptp_xmit_skb_queue(struct 
efx_nic *efx, struct sk_buff *skb)
 >
 >   	tx_queue = efx_channel_get_tx_queue(ptp_data->channel, type);
 >   	if (tx_queue && tx_queue->timestamping) {
 > +		/* This code invokes normal driver TX code which is always
 > +		 * protected from softirqs when called from generic TX code,
 > +		 * which in turn disables preemption. Look at __dev_queue_xmit
 > +		 * which uses rcu_read_lock_bh disabling preemption for RCU
 > +		 * plus disabling softirqs. We do not need RCU reader
 > +		 * protection here.
 > +		 *
 > +		 * Although it is theoretically safe for current PTP TX/RX code
 > +		 * running without disabling softirqs, there are three good
 > +		 * reasond for doing so:
 > +		 *
 > +		 *      1) The code invoked is mainly implemented for non-PTP
 > +		 *         packets and it is always executed with softirqs
 > +		 *         disabled.
 > +		 *      2) This being a single PTP packet, better to not
 > +		 *         interrupt its processing by softirqs which can lead
 > +		 *         to high latencies.
 > +		 *      3) netdev_xmit_more checks preemption is disabled and
 > +		 *         triggers a BUG_ON if not.
 > +		 */
 > +		local_bh_disable();
 >   		efx_enqueue_skb(tx_queue, skb);
 > +		local_bh_enable();
 >   	} else {
 >   		WARN_ONCE(1, "PTP channel has no timestamped tx queue\n");
 >   		dev_kfree_skb_any(skb);

I tested this patch with my X2522, it works well.

test command:
     ptp4l -H -i <sfc interface>

Before this patch, splat looks like:
[ 1464.606891] BUG: using __this_cpu_read() in preemptible [00000000] 
code: kworker/u8:6/100
[ 1464.606949] caller is __efx_enqueue_skb+0xbf/0x1b30 [sfc]
[ 1464.607037] CPU: 3 PID: 100 Comm: kworker/u8:6 Tainted: G        W 
       5.19.0-rc7+ #285 c4ddba47419033e42679f633134da4cdb2a6de42
[ 1464.607081] Hardware name: ASUS System Product Name/PRIME Z690-P D4, 
BIOS 0603 11/01/2021
[ 1464.607109] Workqueue: sfc_ptp efx_ptp_worker [sfc]
[ 1464.607191] Call Trace:
[ 1464.607210]  <TASK>
[ 1464.607228]  dump_stack_lvl+0x57/0x81
[ 1464.607260]  check_preemption_disabled+0xdd/0xe0
[ 1464.607293]  __efx_enqueue_skb+0xbf/0x1b30 [sfc 
f1a1bef35bcab479f96f2aeb5d51c271b89f71ae]
[ 1464.607387]  ? lock_downgrade+0x700/0x700
[ 1464.607420]  ? rcu_read_lock_sched_held+0x12/0x80
[ 1464.607449]  ? lock_acquire+0x478/0x560
[ 1464.607478]  ? rcu_read_lock_sched_held+0x12/0x80
[ 1464.607505]  ? lock_release+0x5c6/0xdf0
[ 1464.607533]  ? rcu_read_lock_sched_held+0x12/0x80
[ 1464.607562]  ? efx_tx_get_copy_buffer_limited+0x230/0x230 [sfc 
f1a1bef35bcab479f96f2aeb5d51c271b89f71ae]
[ 1464.607654]  ? lock_downgrade+0x700/0x700
[ 1464.607684]  ? lock_contended+0xd80/0xd80
[ 1464.607713]  ? do_raw_spin_lock+0x270/0x270
[ 1464.607745]  ? _raw_spin_unlock_irqrestore+0x59/0x70
[ 1464.607774]  ? trace_hardirqs_on+0x3c/0x140
[ 1464.607806]  ? _raw_spin_unlock_irqrestore+0x42/0x70
[ 1464.607840]  efx_ptp_worker+0x6ac/0xec0 [sfc 
f1a1bef35bcab479f96f2aeb5d51c271b89f71ae]
[ 1464.607928]  ? osq_unlock+0x1e0/0x1e0
[ 1464.607961]  ? efx_ptp_rx+0x660/0x660 [sfc 
f1a1bef35bcab479f96f2aeb5d51c271b89f71ae]
[ 1464.608049]  ? lock_downgrade+0x700/0x700
[ 1464.608081]  ? lock_contended+0xd80/0xd80
[ 1464.608112]  ? read_word_at_a_time+0xe/0x20
[ 1464.608149]  process_one_work+0x7c3/0x1300
[ 1464.608184]  ? lockdep_hardirqs_on_prepare+0x410/0x410
[ 1464.608219]  ? pwq_dec_nr_in_flight+0x230/0x230
[ 1464.608247]  ? lock_acquired+0x37e/0xbc0
[ 1464.608291]  worker_thread+0x5ac/0xed0
[ 1464.608329]  ? process_one_work+0x1300/0x1300
[ 1464.608361]  kthread+0x2a4/0x350
[ 1464.608385]  ? kthread_complete_and_exit+0x20/0x20
[ 1464.608416]  ret_from_fork+0x1f/0x30
[ 1464.608458]  </TASK>

After this patch, I can't see any splats.

Thanks,
Taehee Yoo


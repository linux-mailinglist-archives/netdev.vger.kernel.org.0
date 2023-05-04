Return-Path: <netdev+bounces-325-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28C326F71A3
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:55:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C802280DD5
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 17:55:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FA7EBE4C;
	Thu,  4 May 2023 17:55:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EE24A35
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 17:55:34 +0000 (UTC)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ECA92694;
	Thu,  4 May 2023 10:55:33 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1aaea43def7so5419155ad.2;
        Thu, 04 May 2023 10:55:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683222933; x=1685814933;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kYGmSvNgFDY7g35LY35L0BjxtnZwRN1BFpVvX5bSjqA=;
        b=FGxtAsbS7c91Wes4epS1OwkuW/gKvQO1KCveikOJ0pePTF1iuC7n7O8/8AY89Tsfb1
         lY+0iw/eD3guAJiFbd1BoydIZgGZ6ph78pZPPat4mBzNhgFsub0tI6QjdDn+5pt+wvTe
         Waf4EZVMc5BJ4pNl2hn/O73KILcXY9Kg11hDqiGFcaYK0WC4Z4FO7lxT2wiKUIc2XStA
         J/ZE2U/ff9eizeqjMXDgCF52quR7iUkz9GM/6IpOdezDdeaBsGQdymHhJL0PQao4fwV4
         XzI+3jqCNRWd/HdjdmTKwUZrxTwOcx6aFVBG5MN7jZZbIRJCwIrkaobahFMqAfxvhJYF
         eZkg==
X-Gm-Message-State: AC+VfDzYUU4AXQ84MjH0SUrR8sB2jAahKCsU5PLOUbLCjqY8tDRNbwdA
	ouNXVKWpMu8gVeQ+v09ZTLo=
X-Google-Smtp-Source: ACHHUZ7KuPnRR+3jp8S9m88zEhOWRMOn2zzLuliNOUx9/rxh/nwh2z6tIFO3RCXtHKL7OY8spYpQgA==
X-Received: by 2002:a17:902:d50a:b0:1a6:5fa2:3293 with SMTP id b10-20020a170902d50a00b001a65fa23293mr5686816plg.56.1683222932569;
        Thu, 04 May 2023 10:55:32 -0700 (PDT)
Received: from sultan-box.localdomain ([142.147.89.230])
        by smtp.gmail.com with ESMTPSA id f14-20020a170902ab8e00b001aafe56ea70sm7076770plr.5.2023.05.04.10.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 10:55:32 -0700 (PDT)
Date: Thu, 4 May 2023 10:55:29 -0700
From: Sultan Alsawaf <sultan@kerneltoast.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Greenman, Gregory" <gregory.greenman@intel.com>,
	Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"Goodstein, Mordechay" <mordechay.goodstein@intel.com>,
	"Coelho, Luciano" <luciano.coelho@intel.com>,
	"Sisodiya, Mukesh" <mukesh.sisodiya@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wifi: iwlwifi: Fix spurious packet drops with RSS
Message-ID: <ZFPxkRKep27H74Su@sultan-box.localdomain>
References: <20230430001348.3552-1-sultan@kerneltoast.com>
 <8d2b0aec270b8cd0111654dc4b361987a112d3ce.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d2b0aec270b8cd0111654dc4b361987a112d3ce.camel@sipsolutions.net>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 04, 2023 at 02:10:50PM +0200, Johannes Berg wrote:
> [let's see if my reply will make it to the list, the original seems to
> not have]
> 
> On Sun, 2023-04-30 at 00:13 +0000, Sultan Alsawaf wrote:
> > From: Sultan Alsawaf <sultan@kerneltoast.com>
> > 
> > When RSS is used and one of the RX queues lags behind others by more than
> > 2048 frames, then new frames arriving on the lagged RX queue are
> > incorrectly treated as old rather than new by the reorder buffer, and are
> > thus spuriously dropped. This is because the reorder buffer treats frames
> > as old when they have an SN that is more than 2048 away from the head SN,
> > which causes the reorder buffer to drop frames that are actually valid.
> > 
> > The odds of this occurring naturally increase with the number of
> > RX queues used, so CPUs with many threads are more susceptible to
> > encountering spurious packet drops caused by this issue.
> > 
> > As it turns out, the firmware already detects when a frame is either old or
> > duplicated and exports this information, but it's currently unused. Using
> > these firmware bits to decide when frames are old or duplicated fixes the
> > spurious drops.
> 
> So I assume you tested it now, and it works? Somehow I had been under
> the impression we never got it to work back when...

Yep, I've been using this for about a year and have let it run through the
original iperf3 reproducer I mentioned on bugzilla for hours with no stalls. My
big git clones don't freeze anymore either. :)

What I wasn't able to get working was the big reorder buffer cleanup that's made
possible by using these firmware bits. The explicit queue sync can be removed
easily, but there were further potential cleanups you had mentioned that I
wasn't able to get working.

I hadn't submitted this patch until now because I was hoping to get the big
cleanup done simultaneously but I got too busy until now. Since this small patch
does fix the issue, my thought is that this could be merged and sent to stable,
and with subsequent patches I can chip away at cleaning up the reorder buffer.

> > Johannes mentions that the 9000 series' firmware doesn't support these
> > bits, so disable RSS on the 9000 series chipsets since they lack a
> > mechanism to properly detect old and duplicated frames.
> 
> Indeed, I checked this again, I also somehow thought it was backported
> to some versions but doesn't look like. We can either leave those old
> ones broken (they only shipped with fewer cores anyway), or just disable
> it as you did here, not sure. RSS is probably not as relevant with those
> slower speeds anyway.

Agreed, I think it's worth disabling RSS on 9000 series to fix it there. If the
RX queues are heavily backed up and incoming packets are not released fast
enough due to a slow CPU, then I think the spurious drops could happen somewhat
regularly on slow devices using 9000 series.

It's probably also difficult to judge the impact/frequency of these spurious
drops in the wild due to TCP retries potentially masking them. The issue can be
very noticeable when a lot of packets are spuriously dropped at once though, so
I think it's certainly worth the tradeoff to disable RSS on the older chipsets.

> > +++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
> > @@ -918,7 +918,6 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
> >         struct iwl_mvm_sta *mvm_sta;
> >         struct iwl_mvm_baid_data *baid_data;
> >         struct iwl_mvm_reorder_buffer *buffer;
> > -       struct sk_buff *tail;
> >         u32 reorder = le32_to_cpu(desc->reorder_data);
> >         bool amsdu = desc->mac_flags2 & IWL_RX_MPDU_MFLG2_AMSDU;
> >         bool last_subframe =
> > @@ -1020,7 +1019,7 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
> >                                  rx_status->device_timestamp, queue);
> > 
> >         /* drop any oudated packets */
> > -       if (ieee80211_sn_less(sn, buffer->head_sn))
> > +       if (reorder & IWL_RX_MPDU_REORDER_BA_OLD_SN)
> >                 goto drop;
> > 
> >         /* release immediately if allowed by nssn and no stored frames */
> > @@ -1068,24 +1067,12 @@ static bool iwl_mvm_reorder(struct iwl_mvm *mvm,
> >                 return false;
> >         }
> 
> All that "send queue sync" code in the middle that was _meant_ to fix
> this issue but I guess never really did can also be removed, no? And the
> timer, etc. etc.

Indeed, and removing the queue sync + timer are easy. Would you prefer I send
additional patches for at least those cleanups before the fix itself can be
considered for merging?

Sultan


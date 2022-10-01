Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF6B5F1F66
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 22:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiJAUd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 16:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJAUd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 16:33:27 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D58A45061
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 13:33:24 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id g2so4754056qkk.1
        for <netdev@vger.kernel.org>; Sat, 01 Oct 2022 13:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Fk8jhK0skKxmeJUb5JNgCy7u78GSdLOZ+JXwdVte/fA=;
        b=GWZoJNSNgsKmjZStlYXT4F+bvFSpCCh4690pd8pD3BK95FnuMJjEh+3xCgKuPjFNCP
         l46WB9engVqlCgBqxg+Z7iPTXRM9qaTjjY/2FwnMt5QhDVnC1bOlkkWT+40uCKyB1z+h
         LBScXMZjEqIAidK5pCnKprHWFf7KGlQl+++DnsVeO95YmHtI6HEAWgQNbnt2H6l133Na
         ZEQ8n6ss9UNPfM/lVVXBiOMAFYPN/EkGjn2BG9HAsAdF8hmtk4LgE0R+Nr8qvNWvB6te
         2ABkvdq2vK8By0wk61iy4+ER0jZO6aQ/EwcjNnzrfA+b162Ll0bz8SVqBLWrwM3hjHK0
         3l/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Fk8jhK0skKxmeJUb5JNgCy7u78GSdLOZ+JXwdVte/fA=;
        b=pZJ49QxQd54aRZAMZyAA2VsV6SjkMWMQNNz9GksqqGNQIrOtR/lcXBZDBaqqXb96yG
         JOMNwHRiMA7npFY20naja2c2yq6hNCAkdHFe6l4KGhKSCRf70d9mJC0y7AYch2dvpCft
         rVex29HzAzX01BaDx9m6HYWoooNOXd4d3eSfAWF4rzV4iDowcpsOZyl2qKcV1wJtxukZ
         viLHTZ1iSV8VKgJiWANwtHEk7PdgU06kLvLdW+4KT9ODKWYdeNbuQpedepQUSdby3l1T
         izqlBXBBDuNi/x6Z01PsOoMSJ4HX6tx0HkRa8qOYv25wsldmBTNrIf51WnCqrrQTA+IX
         pd0A==
X-Gm-Message-State: ACrzQf00fEbqW/wUMr/qkHafLAbP1JUZKh/DUx5iBES94cP6o95whwbV
        dlRnmKygsBmW3GduqSB/2RW2Im4xuyU=
X-Google-Smtp-Source: AMsMyM4akFSyTAV1gFNNdJBUkbYcQdp1cScIVn4oj0tm+rS24YbK353ucR478sx8RJZO3X0+6hwjJA==
X-Received: by 2002:a37:c49:0:b0:6cc:43ac:a29a with SMTP id 70-20020a370c49000000b006cc43aca29amr9885684qkm.763.1664656403623;
        Sat, 01 Oct 2022 13:33:23 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:a570:880e:2c92:fa00])
        by smtp.gmail.com with ESMTPSA id bl11-20020a05620a1a8b00b006ce30a5f892sm6060391qkb.102.2022.10.01.13.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Oct 2022 13:33:22 -0700 (PDT)
Date:   Sat, 1 Oct 2022 13:33:19 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net v2 1/2] net: Fix return value of qdisc ingress
 handling on success
Message-ID: <YzikD3a8VGTpAiJg@pop-os.localdomain>
References: <1664093662-32069-1-git-send-email-paulb@nvidia.com>
 <1664093662-32069-2-git-send-email-paulb@nvidia.com>
 <YzCXUN6bKSb762Pn@pop-os.localdomain>
 <5a9d0e6a-2916-e791-a123-c8a957a3e3e5@nvidia.com>
 <Yzig5mvDDFqqieDl@pop-os.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yzig5mvDDFqqieDl@pop-os.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 01, 2022 at 01:19:50PM -0700, Cong Wang wrote:
> On Wed, Sep 28, 2022 at 10:55:49AM +0300, Paul Blakey wrote:
> > 
> > 
> > On 25/09/2022 21:00, Cong Wang wrote:
> > > On Sun, Sep 25, 2022 at 11:14:21AM +0300, Paul Blakey wrote:
> > > > Currently qdisc ingress handling (sch_handle_ingress()) doesn't
> > > > set a return value and it is left to the old return value of
> > > > the caller (__netif_receive_skb_core()) which is RX drop, so if
> > > > the packet is consumed, caller will stop and return this value
> > > > as if the packet was dropped.
> > > > 
> > > > This causes a problem in the kernel tcp stack when having a
> > > > egress tc rule forwarding to a ingress tc rule.
> > > > The tcp stack sending packets on the device having the egress rule
> > > > will see the packets as not successfully transmitted (although they
> > > > actually were), will not advance it's internal state of sent data,
> > > > and packets returning on such tcp stream will be dropped by the tcp
> > > > stack with reason ack-of-unsent-data. See reproduction in [0] below.
> > > > 
> > > 
> > > Hm, but how is this return value propagated to egress? I checked
> > > tcf_mirred_act() code, but don't see how it is even used there.
> > > 
> > > 318         err = tcf_mirred_forward(want_ingress, skb2);
> > > 319         if (err) {
> > > 320 out:
> > > 321                 tcf_action_inc_overlimit_qstats(&m->common);
> > > 322                 if (tcf_mirred_is_act_redirect(m_eaction))
> > > 323                         retval = TC_ACT_SHOT;
> > > 324         }
> > > 325         __this_cpu_dec(mirred_rec_level);
> > > 326
> > > 327         return retval;
> > > 
> > > 
> > > What am I missing?
> > 
> > for the ingress acting act_mirred it will return TC_ACT_CONSUMED above
> > the code you mentioned (since redirect=1, use_reinsert=1. Although
> > TC_ACT_STOLEN which is the retval set for this action, will also act the
> > same)
> > 
> > 
> > It is propagated as such (TX stack starting from tcp):
> > 
> 
> Sorry for my misunderstanding.
> 
> I meant to say those TC_ACT_* return value, not NET_RX_*, but I worried
> too much here, as mirred lets user specify the return value.
> 
> BTW, it seems you at least miss the drop case, which is NET_RX_DROP for
> TC_ACT_SHOT at least? Possibly other code paths in sch_handle_ingress()
> too.
> 

I mean:

diff --git a/net/core/dev.c b/net/core/dev.c
index fa53830d0683..d1db8210d671 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5109,6 +5109,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
        struct mini_Qdisc *miniq = rcu_dereference_bh(skb->dev->miniq_ingress);
        struct tcf_result cl_res;

+       *ret = NET_RX_SUCCESS;
        /* If there's at least one ingress present somewhere (so
         * we get here via enabled static key), remaining devices
         * that are not configured with an ingress qdisc will bail
@@ -5136,6 +5137,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
        case TC_ACT_SHOT:
                mini_qdisc_qstats_cpu_drop(miniq);
                kfree_skb_reason(skb, SKB_DROP_REASON_TC_INGRESS);
+               *ret = NET_RX_DROP;
                return NULL;
        case TC_ACT_STOLEN:
        case TC_ACT_QUEUED:
@@ -5160,6 +5162,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
                break;
        }
 #endif /* CONFIG_NET_CLS_ACT */
+       *ret = NET_RX_SUCCESS;
        return skb;
 }



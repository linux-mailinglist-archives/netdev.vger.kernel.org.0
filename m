Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBCB5F1F49
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 22:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiJAUT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 16:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiJAUTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 16:19:55 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A1114013
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 13:19:54 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id r136-20020a4a378e000000b004755953bc6cso4438907oor.13
        for <netdev@vger.kernel.org>; Sat, 01 Oct 2022 13:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ctte0Mek91lhA20t808iSnvb/5T1j3Zi1bWzgCE50gM=;
        b=qSCUIErNtZA/RSmNyXkGIoJNIcVvUzfpmrn/ava2F959nldTdeflakcLZ5lErZrt88
         SfiyJ5Ch85KwptJzCnf2pT/BU6UW6CaQkjRw5DgnMWKeGStzAWvTN5LtXNNMUgoK0js8
         lRqyT1Ki/9Bna5U+sp+2qnqf+DYmayAuqOF7JBuFGzX7serdi2TUGoTwWdfoLtgps3GW
         9nDABSH8cLqiHyGmyVvF/hayClK9Na+IJmHrR8Idr9Dg+vr8ggF1F1DKt+WF6U6+iU6L
         vbZN3mU0bdj/Y8XkZKQpQS3Ztwfs8ur0RGRGvljXbi8ckvJm2FsnkBwjEVtG3nuQe7zd
         x7MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ctte0Mek91lhA20t808iSnvb/5T1j3Zi1bWzgCE50gM=;
        b=JSoTFqgVjimztRYy4PdOEEPnWk02XszIyNgzEYuRqxvtUiwHLjsL2HYpVFPT7/wVfn
         EMGbocZbCOg+1fmL34QM0PqMuu3DasbAAf9NU55VBat4Jljh/21kiR9nQ1HtvBu51C7/
         ssFpzPHifCTsW7WvJRaOatFfkDG0XHDGUJyzZ5FHtsugKdG6a+3tiMtgOP1snMYV8vVk
         s2AVQaSFL7CqZ6BKc1B6i7K6nh95TMZ/1FxHXMABSPJHSKDxV9rQ8b64ldT61PsTUdLX
         QOETJS5nNEkO7P7j+iFtJ+AKcMN4+ofmBuoIWs9TvjG61NHv76szTYm9mbZScxNmbyqr
         8n1A==
X-Gm-Message-State: ACrzQf2tOyIinOL2KgsDirGnefKwqD/2lL3fE9/GDJbzHI6zcPgR7e1O
        noSGZYFzQX0ZNTRD8fMSoy7pOIXTrF0=
X-Google-Smtp-Source: AMsMyM7Qx9Y+Y5eCOItYyuMoq5eANQqSueSRzcg5UMM/rznt+1L1GGYz4cBJ7H74VIp/JI2rJ2goog==
X-Received: by 2002:a05:6830:6b0a:b0:655:f16d:fa4b with SMTP id db10-20020a0568306b0a00b00655f16dfa4bmr5697205otb.164.1664655593855;
        Sat, 01 Oct 2022 13:19:53 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:a570:880e:2c92:fa00])
        by smtp.gmail.com with ESMTPSA id r13-20020a9d750d000000b0063b24357269sm1376292otk.13.2022.10.01.13.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Oct 2022 13:19:53 -0700 (PDT)
Date:   Sat, 1 Oct 2022 13:19:50 -0700
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
Message-ID: <Yzig5mvDDFqqieDl@pop-os.localdomain>
References: <1664093662-32069-1-git-send-email-paulb@nvidia.com>
 <1664093662-32069-2-git-send-email-paulb@nvidia.com>
 <YzCXUN6bKSb762Pn@pop-os.localdomain>
 <5a9d0e6a-2916-e791-a123-c8a957a3e3e5@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a9d0e6a-2916-e791-a123-c8a957a3e3e5@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 10:55:49AM +0300, Paul Blakey wrote:
> 
> 
> On 25/09/2022 21:00, Cong Wang wrote:
> > On Sun, Sep 25, 2022 at 11:14:21AM +0300, Paul Blakey wrote:
> > > Currently qdisc ingress handling (sch_handle_ingress()) doesn't
> > > set a return value and it is left to the old return value of
> > > the caller (__netif_receive_skb_core()) which is RX drop, so if
> > > the packet is consumed, caller will stop and return this value
> > > as if the packet was dropped.
> > > 
> > > This causes a problem in the kernel tcp stack when having a
> > > egress tc rule forwarding to a ingress tc rule.
> > > The tcp stack sending packets on the device having the egress rule
> > > will see the packets as not successfully transmitted (although they
> > > actually were), will not advance it's internal state of sent data,
> > > and packets returning on such tcp stream will be dropped by the tcp
> > > stack with reason ack-of-unsent-data. See reproduction in [0] below.
> > > 
> > 
> > Hm, but how is this return value propagated to egress? I checked
> > tcf_mirred_act() code, but don't see how it is even used there.
> > 
> > 318         err = tcf_mirred_forward(want_ingress, skb2);
> > 319         if (err) {
> > 320 out:
> > 321                 tcf_action_inc_overlimit_qstats(&m->common);
> > 322                 if (tcf_mirred_is_act_redirect(m_eaction))
> > 323                         retval = TC_ACT_SHOT;
> > 324         }
> > 325         __this_cpu_dec(mirred_rec_level);
> > 326
> > 327         return retval;
> > 
> > 
> > What am I missing?
> 
> for the ingress acting act_mirred it will return TC_ACT_CONSUMED above
> the code you mentioned (since redirect=1, use_reinsert=1. Although
> TC_ACT_STOLEN which is the retval set for this action, will also act the
> same)
> 
> 
> It is propagated as such (TX stack starting from tcp):
> 

Sorry for my misunderstanding.

I meant to say those TC_ACT_* return value, not NET_RX_*, but I worried
too much here, as mirred lets user specify the return value.

BTW, it seems you at least miss the drop case, which is NET_RX_DROP for
TC_ACT_SHOT at least? Possibly other code paths in sch_handle_ingress()
too.

Thanks.

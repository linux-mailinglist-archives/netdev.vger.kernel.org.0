Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 736466418A7
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 21:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiLCUTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 15:19:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLCUTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 15:19:21 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791B61D0F7;
        Sat,  3 Dec 2022 12:19:20 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id x28so7885049qtv.13;
        Sat, 03 Dec 2022 12:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UwdVJg7raQtnjUVRTztYGrA3fr8psFlvQUt/25nfn4s=;
        b=WzLBmwlI1VsY9pLVdmvIIscYxAaSw0leKqrziMvspNKdRtaVFiKGz5oF6ueg/cY0LW
         l96OVkH1wweauJNckxTpChAsBFcS7GuFde6QC4W99mA701J85sBJn78wB2pvZj7KPLIC
         ObN79bsGiq1tKb0F0Vs81amOrwQLWIZMax/sar/VhlxtN6UpqpphIXHEqMSY9vek5L7H
         cHHCF7Gn17hmVsGUPrCO8Tlwf9Whueuy8rhV2QLw6nqaGAQABr9YIYmdXPhOYGswM3LU
         4RvOV8Wh5g6ZPXms89eUIkRVryrxOCmYl2XPDFH4qKuotb45pS41TMEVRqxJ+KiUKUgl
         CC+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UwdVJg7raQtnjUVRTztYGrA3fr8psFlvQUt/25nfn4s=;
        b=JywyRRcNpPDIVHlnWj5LRDN7hLWLrTGy9fNqYN5tDY2xRdR//mSVFi46TsKJ61h9kh
         E+EApgOaCyW+SgV78LPYrnSZgH/julENME2V029FZhDOWatv5Lu9mT28wSfXhdqtbPif
         UAuBKX5TKDHC/SbE9Skb2uMZq57Z3vbgewWxsdR66+KJatTM0GQbuGuMuB8Cci1lyyad
         oYQzd97J4InT9/V8CVoTE6Fp0v1677QpvlGPwUXjpWk3TpMuQBfzcAPcg2WAi4YcgFlK
         zWYQHBUx2x1Ig4h8fl1mwWYDa4Sc5cw5EGQbgdlx9KF7O1mdHJvCemeSuDeynkVTbYdh
         7NYQ==
X-Gm-Message-State: ANoB5pk/Y7FxMpBGEbu6zdII4vfxO8WwngFUp5P+R3s0zVeEJfv+BkfY
        i9zBUe8GP3RzP6oRKJniSjU=
X-Google-Smtp-Source: AA0mqf6MG+LmSJ702t7xq9r75ifeYqi0z0yUywrEmEClXAn4mixMcjsVyvqJY7yRPz34fWa8DP9GpQ==
X-Received: by 2002:a05:622a:228c:b0:3a5:c024:7f31 with SMTP id ay12-20020a05622a228c00b003a5c0247f31mr71054100qtb.311.1670098759600;
        Sat, 03 Dec 2022 12:19:19 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:150b:cfdc:d3ab:f038])
        by smtp.gmail.com with ESMTPSA id w18-20020a05620a425200b006cfc9846594sm8666021qko.93.2022.12.03.12.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Dec 2022 12:19:18 -0800 (PST)
Date:   Sat, 3 Dec 2022 12:19:12 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, 18801353760@163.com,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com,
        Cong Wang <cong.wang@bytedance.com>,
        Dmitry Vyukov <dvyukov@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: sched: fix memory leak in tcindex_set_parms
Message-ID: <Y4uvQA2xxtJXltSM@pop-os.localdomain>
References: <20221129025249.463833-1-yin31149@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129025249.463833-1-yin31149@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 10:52:49AM +0800, Hawkins Jiawei wrote:
> Kernel uses tcindex_change() to change an existing
> filter properties. During the process of changing,
> kernel uses tcindex_alloc_perfect_hash() to newly
> allocate filter results, uses tcindex_filter_result_init()
> to clear the old filter result.
> 
> Yet the problem is that, kernel clears the old
> filter result, without destroying its tcf_exts structure,
> which triggers the above memory leak.
> 
> Considering that there already extis a tc_filter_wq workqueue
> to destroy the old tcindex_data by tcindex_partial_destroy_work()
> at the end of tcindex_set_parms(), this patch solves this memory
> leak bug by removing this old filter result clearing part,
> and delegating it to the tc_filter_wq workqueue.

Hmm?? The tcindex_partial_destroy_work() is to destroy 'oldp' which is
different from 'old_r'. I mean, you seem assuming that struct
tcindex_filter_result is always from struct tcindex_data, which is not
true, check the following tcindex_lookup() which retrieves tcindex_filter_result
from struct tcindex_filter.

static struct tcindex_filter_result *tcindex_lookup(struct tcindex_data *p,
                                                    u16 key)
{
        if (p->perfect) {
                struct tcindex_filter_result *f = p->perfect + key;

                return tcindex_filter_is_set(f) ? f : NULL;
        } else if (p->h) {
                struct tcindex_filter __rcu **fp;
                struct tcindex_filter *f;

                fp = &p->h[key % p->hash];
                for (f = rcu_dereference_bh_rtnl(*fp);
                     f;
                     fp = &f->next, f = rcu_dereference_bh_rtnl(*fp))
                        if (f->key == key)
                                return &f->result;
        }

        return NULL;
}

 
> diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
> index 1c9eeb98d826..3f4e7a6cdd96 100644
> --- a/net/sched/cls_tcindex.c
> +++ b/net/sched/cls_tcindex.c
> @@ -478,14 +478,6 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
>  		tcf_bind_filter(tp, &cr, base);
>  	}
>  
> -	if (old_r && old_r != r) {
> -		err = tcindex_filter_result_init(old_r, cp, net);
> -		if (err < 0) {
> -			kfree(f);
> -			goto errout_alloc;
> -		}
> -	}
> -

Even if your above analysis is correct, 'old_r' becomes unused (set but not used)
now, I think you should get some compiler warning.

Thanks.

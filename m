Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0DD2599C33
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 14:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349035AbiHSMoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 08:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349031AbiHSMoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 08:44:20 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C0350066;
        Fri, 19 Aug 2022 05:44:19 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id u9so4618332oiv.12;
        Fri, 19 Aug 2022 05:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=olgvWTHr9jS7KCb0QPjN0Q5SDmG5cWSWO8bFNkf78GM=;
        b=YsEC8qSbFJb+2pn0c5tUK5CAeG6y1dHvZfZ0NSfgRIZX6FQjGTInPfh0y8S3WMXZLp
         Oji1fcGeAtKlnm0L5NggYNQp33wLRhJvq57bUNeKen1apEwup1vV9F75qlXu3lx0W0d1
         YX1oOwGOyQXThIb+oSdBseJTDlytEG2g2QstwFs4eCu5EMOIjSs/+G54gEV9ZQ7cKP3l
         AeKgvsvxgwHz2lV7s8iRnmxO6EGkQoO/0Hl9rPB9BKiNCLxc2YzbNvZMV/2rl0wI9iJU
         7RhFaCsZemxwLrxzU4gt3YFOfmlvaMuLdkBYPmVNjldvtupG13/N+gjEbJvU4EVYldOj
         Z1tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=olgvWTHr9jS7KCb0QPjN0Q5SDmG5cWSWO8bFNkf78GM=;
        b=TE3QQ7Dbg8WYDmvDdMCPnw4HUpZu7PdCiMgdRQPy/w5qBuakAi3L3N/jz3uM6sviWG
         baaAf+whSaPTXOJBxlEUauhEYDgKu/m6bfTrQtUszu1OHOUAk661yU/DvVNgNTr6brxU
         LxzOXuiZZMwHgbKHx4ADp19V490IPEHiLAIts0FtIEIS8liSY9MPRxfmoUDbeuI6Q9sa
         wfFXLDDqpowHYoUiaGB+WdXcb2HoU1k+1EEwPUuXC6MeKPygN6NLx2tPN2odJMh3DpGL
         JMU/mDBNyjcEU3BbrgA3cCLEiEESuNMee9ayJDSVH53LZTbZ7//yFyZxnWEnTFoM6NFE
         4eLg==
X-Gm-Message-State: ACgBeo35Ru9DHUMryYq8tL/QOJz2FUHFRR0q/mpI2Ez90LbvWlYXFlBU
        P5WLkYmt/1kUtSlJh2eicgY=
X-Google-Smtp-Source: AA6agR4TeLAlljlgzU9GM+oiS5UvkUK/mHzEuw8SpgXWqvvKguFcp7gVBgRwHKduQPnsh/7xlsfRmg==
X-Received: by 2002:a05:6808:14cb:b0:344:cc0b:a567 with SMTP id f11-20020a05680814cb00b00344cc0ba567mr5730686oiw.204.1660913058552;
        Fri, 19 Aug 2022 05:44:18 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id x37-20020a056870332500b00101bd4914f9sm1220409oae.43.2022.08.19.05.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 05:44:18 -0700 (PDT)
Date:   Fri, 19 Aug 2022 05:42:06 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:HFI1 DRIVER" <linux-rdma@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH v2 1/5] bitops: Introduce find_next_andnot_bit()
Message-ID: <Yv+FHpyZ6gpIAXMw@yury-laptop>
References: <20220817175812.671843-1-vschneid@redhat.com>
 <20220817175812.671843-2-vschneid@redhat.com>
 <20220818100820.3b45808b@gandalf.local.home>
 <xhsmh35dtbjr0.mognet@vschneid.remote.csb>
 <20220818130041.5b7c955f@gandalf.local.home>
 <CAHp75VcaSwfy7kOm_d28-87QKQ5KPB69=X=Z9OYUzJJKwRCSmQ@mail.gmail.com>
 <xhsmhk074a5eu.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xhsmhk074a5eu.mognet@vschneid.remote.csb>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 11:34:01AM +0100, Valentin Schneider wrote:
> On 18/08/22 22:04, Andy Shevchenko wrote:
> > On Thu, Aug 18, 2022 at 8:18 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> >> On Thu, 18 Aug 2022 17:26:43 +0100
> >> Valentin Schneider <vschneid@redhat.com> wrote:
> >>
> >> > How about:
> >>
> >> >
> >> >   find the next set bit in (*addr1 & ~*addr2)
> >>
> >> I understand the above better. But to convert that into English, we could
> >> say:
> >>
> >>
> >>   Find the next bit in *addr1 excluding all the bits in *addr2.
> >>
> >> or
> >>
> >>   Find the next bit in *addr1 that is not set in *addr2.
> >
> > With this explanation I'm wondering how different this is to
> > bitmap_bitremap(), with adjusting to using an inverted mask. If they
> > have something in common, perhaps make them in the same namespace with
> > similar naming convention?
> >
> 
> I'm trying to wrap my head around the whole remap thing, IIUC we could have
> something like remap *addr1 to ~*addr2 and stop rather than continue with a
> wraparound, but that really feels like shoehorning.

Old and new maps create a simple forward-looking mapping, like this:
    #0   #4
old: 0111 0 ...
     | \\\|
New: 00 111 ...

So if you pass #0, it's wired to 0; but #1 will skip 1 bit and would be
wired to 2; and so on. There is some puzzling when wraparound comes in
play, but the general idea is like that.

I think there's nothing common with bitmap_and{,_not}.

Thanks,
Yury

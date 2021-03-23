Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A833455B3
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 03:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhCWCuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 22:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhCWCti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 22:49:38 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70A8C061574;
        Mon, 22 Mar 2021 19:49:36 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id g15so12756841pfq.3;
        Mon, 22 Mar 2021 19:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=qLL8u5RSXlub/wH8MDjMwEUdn29GdY6zDkOzgBhcmM8=;
        b=e6eJITmSA7f+krGA6GYWV+FebWY2FScfRNz2CdKLYScWisVUw5CtpkC0gPCYyv33R4
         06rwpmtMSCUw4Ixj9x6NngBxk2s8CTFs+w/ABMXSbWpajG7Rkr/uiyqifrxc/aF7hJg6
         1ksaqWn9f+/p3t70QhohHvY5T5JYRL/Af2XXhOKWysk/BdBosIh28pk+zfd0am8lXR9V
         MCQmMQs/Di37wlQPRbcK9aKDoG46ErNIV+FViUr0M4leOSjL9h2re1TFLfUO+ixjYDiL
         dbo41F8pAen1ytzok1xtsmFDvkvryZ5X4ZQLJzKbCFVjfNsJciltgXnWD7bugTVanECb
         orMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=qLL8u5RSXlub/wH8MDjMwEUdn29GdY6zDkOzgBhcmM8=;
        b=kDbb5rhBmvP3lwoGpVrNuVDb/N+IkWduW/JlH/E6xotukiKcMiJMOek0l5fUSKwahR
         hDSA8UnCJqUf7fe3M7uqet48moe8MBKmAjOuLbbSx46J4iWLpgONF0nJHP4GpMT4zyEm
         m2IUGkCFuG3JmGHkm6XeDvRwrDlF6Zu3GO31tN1mTh34pcO1S2NyL2BcA4t7kc7Q0qOX
         khLLu7R8jDhZ+Shu4GoUVN5sLHOrg5zqtxE7XgQI3J3fnHBkkGMWJMT2gRQmVfrYCI+9
         R1oYX0NiJd/lUZ2lAxNNnPsJDkRaTYoPUOmQLFpzl2IQlANc2B8sRsWy9VMxwMU17SQZ
         v+jw==
X-Gm-Message-State: AOAM530PxIzzbQoVYK64ZlR+YZU7fodyxv2me7gIMETDTyuZ0McMS2GB
        FbVzL7HxpUwMnIERzMZIMlo=
X-Google-Smtp-Source: ABdhPJxZnXmNSgKqUTdnPPFB0+aT9tb/9hccz1qSl82B4/gydZYPw99Jh9P0fbkwK54g7WUGMGf3VA==
X-Received: by 2002:a63:1026:: with SMTP id f38mr2185821pgl.142.1616467776370;
        Mon, 22 Mar 2021 19:49:36 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 144sm5483383pfy.75.2021.03.22.19.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 19:49:35 -0700 (PDT)
Date:   Tue, 23 Mar 2021 10:49:23 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bjorn@kernel.org
Subject: Re: [PATCHv2 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Message-ID: <20210323024923.GD2900@Leo-laptop-t470s>
References: <20210309101321.2138655-1-liuhangbin@gmail.com>
 <20210309101321.2138655-3-liuhangbin@gmail.com>
 <87r1kec7ih.fsf@toke.dk>
 <20210318035200.GB2900@Leo-laptop-t470s>
 <875z1oczng.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <875z1oczng.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 03:19:47PM +0100, Toke Høiland-Jørgensen wrote:
> Hangbin Liu <liuhangbin@gmail.com> writes:
> 
> > On Wed, Mar 17, 2021 at 01:03:02PM +0100, Toke Høiland-Jørgensen wrote:
> >> FYI, this no longer applies to bpf-next due to Björn's refactor in
> >> commit: ee75aef23afe ("bpf, xdp: Restructure redirect actions")
> >
> > Thanks Toke, I need to see how to get the map via map_id, does
> > bpf_map_get_curr_or_next() works? Should I call bpf_map_put() after
> > using?
> 
> I would expect that to be terrible for performance; I think it would be
> better to just add back the map pointer into struct bpf_redirect_info.
> If you only set the map pointer when the multicast flag is set, you can
> just check that pointer to disambiguate between when you need to call
> dev_map_enqueue() and dev_map_enqueue_multi(), in which case you don't
> need to add back the flags member...

There are 2 flags, BROADCAST and EXCLUDE_INGRESS. There is no way
to only check the map pointer and ignore flags..

Thanks
Hangbin

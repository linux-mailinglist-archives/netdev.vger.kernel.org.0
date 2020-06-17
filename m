Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9F91FC5EE
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 08:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgFQGDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 02:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgFQGDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 02:03:08 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3056C061573;
        Tue, 16 Jun 2020 23:03:08 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id a13so1030220ilh.3;
        Tue, 16 Jun 2020 23:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=BYJ/7pT0d3KlLwz2ALkCpZy3QnaYFBsCD0fEwqLaLPo=;
        b=DWVrwfHT4bhRWwhiCtHcdIzPr8HUYKFSheNx5ZN1LwGQCSwCFoicekzpZGX6kepSKy
         9ea7Tyq8R19g5b+hFGMKlvTApGys1U8Vs4i2dSkw1bqpNESgLJ52kA7i0aU2XOLhLWRN
         wfjryFS6PYriX8Ae2QvjEYqBUN6oD746HZUcJYaGYfUDLDiuq+7vKIwB/jcYvELmeKHh
         kDz8VJgmCfZATrbQdmAr6uyFdpsuVf95xBogCmJ2UToht6aUII/NGwqodwuIqQV7wb7K
         caAvJwOGBncQWZAvyYJlJg3LCYMV9RuEzZruPuuGJK8GWj4MoFbJchc4dxoHbxDjATJz
         vqwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=BYJ/7pT0d3KlLwz2ALkCpZy3QnaYFBsCD0fEwqLaLPo=;
        b=uLqvWhWx0gtiBmSuKIVfluAZkQoP18cGXCTf56P86NzjQX1IDgWs99MiiONXwfGxqn
         7HgIdHk7w+PKur8K++uC9//uFepVyfdvESZKv9uQ9ihozCjoLMFDeoZLjcfa+xHI/5mQ
         5CgLUEzurME7smbncp7IRwuobYZ+jtmbKFe+32sdzEKe4dl3clUnF/HoTAkDBLtPp3zM
         EpxWQT7oE8GNqNybEejeiu2QQOc9sQFwsLAtBpkRkHxL/9i6yk8sw5ppWpNs3uK6bvfF
         nEqJW2a34VX75ofDswDIsV0nkAqHcxy5SxGgCXCVHue2Qq/nqQgInhHwyYvNOPQT7LtX
         XiDw==
X-Gm-Message-State: AOAM531ha2LUCg75FUG5a0342cUpzAmgIz4a3uS/JNjYFUMug5j3XNxJ
        IgWCE6dnk+OoYd/daiJKN+Q=
X-Google-Smtp-Source: ABdhPJzrWTIHmOmvCEbXcIsuqFdziMQHHQ3WNpYoLGi+AKDexWr2PV+sxLjyky6EUdo0JPMnP7TNiw==
X-Received: by 2002:a92:48cf:: with SMTP id j76mr6818354ilg.270.1592373787985;
        Tue, 16 Jun 2020 23:03:07 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 65sm11267342ilv.7.2020.06.16.23.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 23:03:07 -0700 (PDT)
Date:   Tue, 16 Jun 2020 23:02:58 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, brouer@redhat.com
Message-ID: <5ee9b212af6a1_1d4a2af9b18625c434@john-XPS-13-9370.notmuch>
In-Reply-To: <20200616171233.1579d079@carbon>
References: <20200616103518.2963410-1-liuhangbin@gmail.com>
 <20200616171233.1579d079@carbon>
Subject: Re: [PATCH bpf] xdp: handle frame_sz in xdp_convert_zc_to_xdp_frame()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> On Tue, 16 Jun 2020 18:35:18 +0800
> Hangbin Liu <liuhangbin@gmail.com> wrote:
> 
> > In commit 34cc0b338a61 we only handled the frame_sz in convert_to_xdp_frame().
> > This patch will also handle frame_sz in xdp_convert_zc_to_xdp_frame().
> > 
> > Fixes: 34cc0b338a61 ("xdp: Xdp_frame add member frame_sz and handle in convert_to_xdp_frame")
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> Thanks for spotting and fixing this! :-)
> 
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75D41E4F86
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 22:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgE0Uox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 16:44:53 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:47028 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726129AbgE0Uox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 16:44:53 -0400
Received: from mxbackcorp1j.mail.yandex.net (mxbackcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::162])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 4E4292E15A9;
        Wed, 27 May 2020 23:44:50 +0300 (MSK)
Received: from localhost (localhost [::1])
        by mxbackcorp1j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id pIxtzWRvmm-inFqebhx;
        Wed, 27 May 2020 23:44:50 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1590612290; bh=8gWEH5QZGC/k0mRrkpRwUrBGT1axkv9pVZIipU6CMYU=;
        h=Subject:In-Reply-To:Cc:Date:References:To:From:Message-Id;
        b=CFtzeywQpgK4qiCL3iaQX5EjZdI34pZFGb9y0fZKNv5lEnTA50P0d2pB4VSP7+eSE
         LnaCmSnKFE2I88UMDaOTz4uO57wbmwwU/+lvXG90YFoCMtnAtnav2kiqW8ALXWgdMh
         fEvpUgkAD03H1Cyt7FpI3u6zEGd+koSoS19prUZ0=
Authentication-Results: mxbackcorp1j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
X-Yandex-Sender-Uid: 1120000000093952
X-Yandex-Avir: 1
Received: from mxbackcorp1j.mail.yandex.net (localhost [::1])
        by mxbackcorp1j.mail.yandex.net with LMTP id 0E7VedFjnq-tjulvy5D
        for <zeil@yandex-team.ru>; Wed, 27 May 2020 23:44:38 +0300
Received: by vla1-bfecef18a7a0.qloud-c.yandex.net with HTTP;
        Wed, 27 May 2020 23:44:38 +0300
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "brakmo@fb.com" <brakmo@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <20200527170221.iutwmch6sim35bkt@kafai-mbp>
References: <20200527150543.93335-1-zeil@yandex-team.ru> <20200527170221.iutwmch6sim35bkt@kafai-mbp>
Subject: Re: [PATCH bpf-next] bpf: add SO_KEEPALIVE and related options to bpf_setsockopt
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date:   Wed, 27 May 2020 23:44:48 +0300
Message-Id: <80511590611840@mail.yandex-team.ru>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



27.05.2020, 20:03, "Martin KaFai Lau" <kafai@fb.com>:
> On Wed, May 27, 2020 at 06:05:43PM +0300, Dmitry Yakunin wrote:
>>  This patch adds support of SO_KEEPALIVE flag and TCP related options
>>  to bpf_setsockopt() routine. This is helpful if we want to enable or tune
>>  TCP keepalive for applications which don't do it in the userspace code.
>>  In order to avoid copy-paste, common code from classic setsockopt was moved
>>  to auxiliary functions in the headers.
>
> Thanks for refatoring some of the pieces. I suspect some more can be done.
> In the long run, I don't think this copy-and-paste is scalable.
> For most of the options (integer value and do not need ns_capable()),
> do_tcp_setsockopt() and sock_setsockopt() can be directly called with
> some refactoring.
>
> The change looks good. For this patch,
>
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Thanks for your comment, Martin.
I agree with you, bpf_setsockopt and older setsockopts should be refactored to use common code.
I'll keep this in mind if i want to add new options.

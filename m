Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10FE0AF0A0
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 19:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437162AbfIJRpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 13:45:39 -0400
Received: from mail02.iobjects.de ([188.40.134.68]:47236 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437138AbfIJRpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 13:45:39 -0400
Received: from tux.wizards.de (pD9EBF359.dip0.t-ipconnect.de [217.235.243.89])
        by mail02.iobjects.de (Postfix) with ESMTPSA id 6F5B941607FE;
        Tue, 10 Sep 2019 19:45:37 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 1F68EF015AB;
        Tue, 10 Sep 2019 19:45:37 +0200 (CEST)
Subject: Re: Default qdisc not correctly initialized with custom MTU
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>
References: <211c7151-7500-f895-7fd7-2c868dd48579@applied-asynchrony.com>
 <CAM_iQpWKsSWDZ55kMO6mzDe5C7tHW-ub_eH91hRzZMdUtKJtfA@mail.gmail.com>
 <dbc359d3-5cac-9b2e-6520-df4a25964bd3@applied-asynchrony.com>
 <CAM_iQpUO3vedg+XOcMb8s6hE=+hdvjPJp9DitjHZE6oNtDVkVQ@mail.gmail.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <928db740-b80d-02d5-5846-5d34ea709579@applied-asynchrony.com>
Date:   Tue, 10 Sep 2019 19:45:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpUO3vedg+XOcMb8s6hE=+hdvjPJp9DitjHZE6oNtDVkVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/10/19 6:56 PM, Cong Wang wrote:
> It is _not_ created when sysctl is configured, it is either created via tc
> command, or implicitly created by kernel when you bring up eth0.
> sysctl only tells kernel what to create by default, but never commits it.

Ok, thank you - that's good to know, because it means there is something
wrong with how my interface is initially brought up. And indeed I found
the problem: my startup scripts apparently bring up the interface twice -
once to "pre-start" (load/verify modules etc.) and then again after
applying mtu/route/etc. settings. Obviously without MTU bringing up the
interface will pull in the default qdisc in the interface's default config,
and that's what I saw after boot. Weird but what can I say.

Anyway, thanks for trying to help. :)

Holger

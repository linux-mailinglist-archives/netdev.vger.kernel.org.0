Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D094380659
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 15:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbfHCNm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 09:42:28 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:14178 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbfHCNm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 09:42:28 -0400
Received: from [192.168.1.4] (unknown [222.68.27.146])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 57A30415DE;
        Sat,  3 Aug 2019 21:42:21 +0800 (CST)
Subject: Re: [PATCH net-next v5 5/6] flow_offload: support get flow_block
 immediately
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     jiri@resnulli.us, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        John Hurley <john.hurley@netronome.com>
References: <1564628627-10021-1-git-send-email-wenxu@ucloud.cn>
 <1564628627-10021-6-git-send-email-wenxu@ucloud.cn>
 <20190801161129.25fee619@cakuba.netronome.com>
 <bac5c6a5-8a1b-ee74-988b-6c2a71885761@ucloud.cn>
 <55850b13-991f-97bd-b452-efacd0f39aa4@ucloud.cn>
 <20190802110216.5e1fd938@cakuba.netronome.com>
 <45660f1e-b6a8-1bcb-0d57-7c1790d3fbaf@ucloud.cn>
 <20190802172155.7a36713d@cakuba.netronome.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <57c751f3-4b8e-7eb9-2ae0-1d72ca2c35e2@ucloud.cn>
Date:   Sat, 3 Aug 2019 21:42:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802172155.7a36713d@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVQ01NS0tLSUJPTUNOSE1ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MUk6LDo6LDg8Lk4BEhw9EAs1
        HgIaCi5VSlVKTk1PQ0hCTE9KTU1DVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUlJSVVN
        Q1VJTFVKT01ZV1kIAVlBSU1JQjcG
X-HM-Tid: 0a6c57b788ac2086kuqy57a30415de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2019/8/3 8:21, Jakub Kicinski 写道:
> On Sat, 3 Aug 2019 07:19:31 +0800, wenxu wrote:
>>> Or:
>>>
>>> device unregister:
>>>   - nft block destroy
>>>     - UNBIND cb
>>>       - free driver's block state
>>>   - driver notifier callback
>>>     - free driver's state
>>>
>>> No?  
>> For the second case maybe can't unbind cb? because the nft block is
>> destroied. There is no way to find the block(chain) in nft.
> But before the block is destroyed doesn't nft send an UNBIND event to
> the drivers, always?
you are correct, it will be send an UBIND event when the block is destroyed

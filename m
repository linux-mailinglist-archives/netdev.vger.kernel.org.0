Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC943B0B0
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 10:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388395AbfFJIWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 04:22:47 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:54994 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387825AbfFJIWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 04:22:47 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id BD2C541B91
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 16:22:43 +0800 (CST)
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
From:   wenxu <wenxu@ucloud.cn>
Subject: rtnetlink dump operations also share the rrtnl_mutex
Message-ID: <d2d3f366-4082-cc0f-7b3a-73573ef887b6@ucloud.cn>
Date:   Mon, 10 Jun 2019 16:22:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kIGBQJHllBWUhVSk9CS0tLSk1MQ09NTUNZV1koWUFJQjdXWS1ZQUlXWQ
        kOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Phw6Tww6ETgrEB4tNTYIEB8p
        E1YwCjhVSlVKTk1LSk5PQk1IQ0xJVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSklKSjcG
X-HM-Tid: 0a6b407b7f622086kuqybd2c541b91
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,


When a netlink_route socket was created, the nlk->cb_mutex is get through nl_table[NETLINK_ROUTE].cb_mutex which is the rtnl_mutex.


So all the netlink_route dump operation can contend for each other (ip l, ip a, ip r, tc ls). It will also contend with other RTM_NEW/DEL operations.


So there can be a good way for each msgtype have their own mutex for dump operations?


BR

wenxu




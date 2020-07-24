Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C07A22C58F
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 14:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgGXMva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 08:51:30 -0400
Received: from mail.corporatemx.com ([78.140.179.7]:17891 "EHLO
        mail.corporatemx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgGXMva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 08:51:30 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jul 2020 08:51:29 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=servers.com
        ; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
        Message-ID:Subject:From:To:Sender:Reply-To:Cc:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2hRURaCWUciAn/c/BXwM3RuKRvRc5c2VihuUH9pOtJ4=; b=KT08PcTNnDY3eX2Fa4ckB7Utkj
        szaf+n7W4Arl0pm7EhOWv2bMp67a7lAgz8mU6xWD2HAAd00qyrWSLzkp37uf7c/z6NZ8mBFRlrOYI
        4ILlQgXYGSEeVt09OrFPA8UMvRIwGfFlO2F3+OtDW/3NU6ji8Mbyf/NKDFN1dZ7Kc0mU=;
Received: from [109.110.245.170] (port=28730 helo=[192.168.0.152])
        by mail.corporatemx.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (envelope-from <amarao@servers.com>)
        id 1jyx4j-000E9J-Nz
        for netdev@vger.kernel.org; Fri, 24 Jul 2020 14:45:21 +0200
To:     netdev@vger.kernel.org
From:   George Shuklin <amarao@servers.com>
Subject: Bug in iproute2 man page (or in iproute itself)
Message-ID: <869fed82-bb31-589f-bd26-591ccfa976ed@servers.com>
Date:   Fri, 24 Jul 2020 15:45:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

I'm writing Ansible module for iproute, and I found some discrepancies 
between man page and actual behavior for ip link add type bridge.

man page said:

hello_time HELLO_TIME - set the time in seconds between hello packets 
sent by the bridge, when it is a root bridge or a designated bridges.  
Only relevant if STP
is enabled. Valid values are between 1 and 10.

max_age MAX_AGE - set the hello packet timeout, ie the time in seconds 
until another bridge in the spanning tree is assumed to be dead, after 
reception of its
last hello message. Only relevant if STP is enabled. Valid values are 
between 6 and 40.

In reality 'ip link add type bridge' requires hello_time to be at least 
100, and max_age to be at least 600. I suspect there is a missing x100 
multiplier, either in docs, or in the code.

(I'm not sure where I should send bugreports for iproute2).


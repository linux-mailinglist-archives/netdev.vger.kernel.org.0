Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF16C16EB6C
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 17:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730939AbgBYQ3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 11:29:40 -0500
Received: from sender11-of-f72.zoho.eu ([31.186.226.244]:17817 "EHLO
        sender11-of-f72.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbgBYQ3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 11:29:39 -0500
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Feb 2020 11:29:38 EST
Received: from [172.30.220.169] (163.114.130.128 [163.114.130.128]) by mx.zoho.eu
        with SMTPS id 158264725127230.28543562251855; Tue, 25 Feb 2020 17:14:11 +0100 (CET)
Subject: Re: [PATCH][next] wireless: realtek: Replace zero-length array with
 flexible-array member
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200225002746.GA26789@embeddedor>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <04cba503-9de8-0b61-8d97-77bf47392ef5@trained-monkey.org>
Date:   Tue, 25 Feb 2020 11:14:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200225002746.GA26789@embeddedor>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/20 7:27 PM, Gustavo A. R. Silva wrote:
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
> 
> struct foo {
>         int stuff;
>         struct boo array[];
> };
> 
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
> 
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
> 
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
> 
> This issue was found with the help of Coccinelle.

Hi Gustavo,

I really don't think this improves the code in any way for the drivers
you are modifying. If we really want to address this corner case, it
seems like fixing the compiler to address [0] arrays the same as []
arrays is the right solution.

Cheers,
Jes


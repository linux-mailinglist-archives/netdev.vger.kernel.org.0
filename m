Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2953D0006
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 19:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbhGTQiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 12:38:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229790AbhGTQhQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 12:37:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3387610D2;
        Tue, 20 Jul 2021 17:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626801467;
        bh=MgbhYLSjcMKKNs8xjxBsytwleBUXjDkbtocX0dAcJrM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=VzQLszJyQAmQTrFwb/w+CXuenh/YNiHdaV7SmqZgVbCa3YcbhxOlydPrRth4aTdHJ
         3eM7r4jw0pHffWKyFgFCBQ+lZ/BK7Zxfizj1ArUKsavjer/GsCCQgqaspjW2kZ3y/Q
         /cNt/roMxdRdIWspMYANXqmSlqMf2TZKIJO1I8hOX08UQ9BgFhXcRdu54IaHgyvf71
         HZroGnAnh7C5BmlVfDMacpzYYfj1h61uIxeO9tLXzumrYpO6Q+8dHBxlIU71vQoZP8
         3nd48RkyuqceEpxJwiORRdbh8920r7ZGGt1S2qQhf3LX4yQS4HR8K8gCthO+8QppAf
         dCi5qYLems+vA==
Subject: Re: [PATCH] atm: idt77252: clean up trigraph warning on ??) string
To:     Colin King <colin.king@canonical.com>,
        Chas Williams <3chas3@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        clang-built-linux@googlegroups.com
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210720124813.59331-1-colin.king@canonical.com>
From:   Nathan Chancellor <nathan@kernel.org>
Message-ID: <fd4f465b-86bd-129d-c6d9-e802b7c4815e@kernel.org>
Date:   Tue, 20 Jul 2021 10:17:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210720124813.59331-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/2021 5:48 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The character sequence ??) is a trigraph and causes the following
> clang warning:
> 
> drivers/atm/idt77252.c:3544:35: warning: trigraph ignored [-Wtrigraphs]
> 
> Clean this by replacing it with single ?.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

This looks good to me but I am curious how you say this warning in the 
first place since the main Makefile disables this unconditionally. Did 
you just pass -Wtrigraphs via KCFLAGS or something similar?

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>   drivers/atm/idt77252.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
> index 9e4bd751db79..81ce81a75fc6 100644
> --- a/drivers/atm/idt77252.c
> +++ b/drivers/atm/idt77252.c
> @@ -3536,7 +3536,7 @@ static int idt77252_preset(struct idt77252_dev *card)
>   		return -1;
>   	}
>   	if (!(pci_command & PCI_COMMAND_IO)) {
> -		printk("%s: PCI_COMMAND: %04x (???)\n",
> +		printk("%s: PCI_COMMAND: %04x (?)\n",
>   		       card->name, pci_command);
>   		deinit_card(card);
>   		return (-1);
> 

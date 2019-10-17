Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5800DB613
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391986AbfJQSZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:25:37 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:38683 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728292AbfJQSZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:25:37 -0400
Received: from [167.98.27.226] (helo=xylophone)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iLASq-00073C-Gr; Thu, 17 Oct 2019 19:25:32 +0100
Message-ID: <20ef0181f615a6dfe8698afb52597164d74f8637.camel@codethink.co.uk>
Subject: Re: [Y2038] [PATCH v6 16/43] compat_ioctl: move isdn/capi ioctl
 translation into driver
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>
Cc:     Karsten Keil <isdn@linux-pingi.de>, y2038@lists.linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        isdn4linux@listserv.isdn4linux.de, linux-fsdevel@vger.kernel.org
Date:   Thu, 17 Oct 2019 19:25:31 +0100
In-Reply-To: <20191009191044.308087-16-arnd@arndb.de>
References: <20191009190853.245077-1-arnd@arndb.de>
         <20191009191044.308087-16-arnd@arndb.de>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-10-09 at 21:10 +0200, Arnd Bergmann wrote:
[...]
> --- a/drivers/isdn/capi/capi.c
> +++ b/drivers/isdn/capi/capi.c
> @@ -950,6 +950,34 @@ capi_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  	return ret;
>  }
>  
> +#ifdef CONFIG_COMPAT
> +static long
> +capi_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	int ret;
> +
> +	if (cmd == CAPI_MANUFACTURER_CMD) {
> +		struct {
> +			unsigned long cmd;

Should be u32?

Ben.

> +			compat_uptr_t data;
> +		} mcmd32;
[...]

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom


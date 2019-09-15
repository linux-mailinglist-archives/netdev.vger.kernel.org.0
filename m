Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E01FB314A
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 20:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbfIOSAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Sep 2019 14:00:07 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42610 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbfIOSAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Sep 2019 14:00:07 -0400
Received: by mail-pf1-f194.google.com with SMTP id q12so929542pff.9
        for <netdev@vger.kernel.org>; Sun, 15 Sep 2019 11:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fp3yTeJp7xu+Wocy2O8wpCvPCjR57Csg7O1hhyf1rDI=;
        b=qH/g0Q67mUfDV3ywsMIVaQAVBAuJfXr5zbIXXS9loJarh1m2ljyPCDBJsVl3be+z27
         zvupQpECBaEeJ2xyPROL0YNDDqlUdPn2wTE4mbt/3uz2DzhOQzsTekHMvsh45oqmOYMf
         QR82RXEL6PlYcHNsuqo5miUw9MS2UHPF6UvMCHnM5S7IVFnWXIQU1UuAeBIWMnFvfJOo
         G0TP4hRtHPaoeWIos+a5dKr14kftNHkJ0sas/kb3T9b0UIuLL8Y/rIbo/ptR3uVm86Oa
         daPfCwpOSkd+7Y84TsA89H6zde562wAG44qeQCjp4R4ZHeBC+Fy1pkSOaGnxGa0/X6Gl
         yL5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fp3yTeJp7xu+Wocy2O8wpCvPCjR57Csg7O1hhyf1rDI=;
        b=ckXuzozzHaRNYyIH8GqYAzRN1vzIKJwEe7Bg7qGAv9Yg1V9cVqN+05N24oaM/GDsSG
         ieLZ/1o5Os25YhItfKuaG85aMOdmjjy0hw1JyEiXLO7hNKOXlnTwwZlzYtlaUuKYeaYx
         V5wS2SOFLTilGeElBy3k0pgTt0PToMIc1QLrkym70CcDTbzFJSz4KsiknC/0MzU1e8t/
         o3qXJ7qr0cjUeJ784vYdjMO0OK4KuWZ1fBO0ruR7Neklz4WPe9ldT08CzXJ0rZN5acqj
         Bls1tepivgqQmN39EssVyDCmCP4O61Qnep7ab3zM+oqvh6Nucx/RvaCZhcUXnSyybVJC
         USZA==
X-Gm-Message-State: APjAAAWW76veOAFkra2Hi6nN+XMYV0/uV6bdMRQvojZ+8rvr59vXykSX
        /ZYdbDi4KMgCBC+XLqbPUFg=
X-Google-Smtp-Source: APXvYqyo27LUZh7YtbXKl4+tSaTOosfiIgCf1DdIUMn4k0NsXkn4s1L7er+hHQdmEphxfmoEJV6c9Q==
X-Received: by 2002:a62:5fc1:: with SMTP id t184mr34464870pfb.84.1568570406982;
        Sun, 15 Sep 2019 11:00:06 -0700 (PDT)
Received: from [172.27.227.180] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id z22sm1948535pgf.10.2019.09.15.11.00.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 11:00:06 -0700 (PDT)
Subject: Re: [patch iproute2-next] devlink: add reload failed indication
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, idosch@mellanox.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        mlxsw@mellanox.com
References: <20190914065637.27226-1-jiri@resnulli.us>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <42c5e661-a4ba-fae8-cc11-f088e3a8e480@gmail.com>
Date:   Sun, 15 Sep 2019 12:00:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190914065637.27226-1-jiri@resnulli.us>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/14/19 12:56 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 

Please add a description here - e.g., what change is there to user output.

> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  devlink/devlink.c            | 22 +++++++++++++++-------
>  include/uapi/linux/devlink.h |  2 ++
>  2 files changed, 17 insertions(+), 7 deletions(-)
> 

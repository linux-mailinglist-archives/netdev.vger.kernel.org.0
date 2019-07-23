Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2BC371DF1
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 19:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388682AbfGWRrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 13:47:36 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36237 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732899AbfGWRrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 13:47:35 -0400
Received: by mail-pg1-f194.google.com with SMTP id l21so19780103pgm.3
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 10:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TnEydTCCD8Aa8sGo6Qf1yOa8TUO59CkWZAKjDk0hiK0=;
        b=C/KAbJ0FzAhJHlxfHLKxd2QAugjP2OcGC9dre2wWsHQXf0PA1Tb9hRxAq0HRpOGQdJ
         EQKPWdtdvm9bn4C5KW/JjMg8GEPDicZtw9UA8Vr1qX1rX5H4YvKO2fUGR7oFptb59m9/
         3haKAhtrTM30fr/u3LiG810jpwb9UJJD6KpGUFrRr+F42Wby9t8NhWkl8yFMEOpo69m/
         yS+/gAYSv6Y6+myx95z/BHTJDYdjQT6M2kkg9SJxb1XvyI9dYRffDg9mkqy+Y90lq7Yk
         z9sXYZUvvL9qWk3kHBNoiM6VZ2YIBZX2jSxS/pnPN326giGkEiP/z5uyCAUY2y7ZonlP
         y+mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TnEydTCCD8Aa8sGo6Qf1yOa8TUO59CkWZAKjDk0hiK0=;
        b=QW5Xh8DB3VFJt/HgiUMJttuHoJXmPwW5+Qdpd3Ku75EaT4G4gFx8uuUTF4bbnvtbNB
         sYFIVTV4L9ZtRi67t5ibR08a/qL0yxmCPaFBSOQR+bjq3INF4ehbtqfkc3OP3vtgdLV8
         qwDTfvxnwYIUuz7ryqbi7u5JlWjQHs+jNYp5KQhl4b65s6hLKc/jpSCe2ViiuTZ3svav
         GsTSLEynoYXRnkuEmynTleUnQwnTqeI86CObeD/9AUDllVzm/HsM790CylGEs6YWy+W+
         8db8qU10Xeyx75E2vE8/Us91sYz4x9/swh6yXuoQpiqd7gR3HHXAAIgv/elLz0fTxuQW
         cdgw==
X-Gm-Message-State: APjAAAWqAoy19nBoQOHDu4iVsdptuC5ZmyS6Re2o5qcS3F64wAFDWiYJ
        Jmf4mQK21kHXuYgC38QWLeU=
X-Google-Smtp-Source: APXvYqxJsmRHLo2G0Inj70tPK2c+7v4tziQmvh1dualur1lfd2TvHpXsRGffMyIXuW+ZwQ1xrUUWZA==
X-Received: by 2002:a17:90a:bf08:: with SMTP id c8mr83315552pjs.75.1563904055154;
        Tue, 23 Jul 2019 10:47:35 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id w22sm47116962pfi.175.2019.07.23.10.47.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 10:47:34 -0700 (PDT)
Date:   Tue, 23 Jul 2019 10:47:32 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, sthemmin@microsoft.com, dsahern@gmail.com,
        alexanderk@mellanox.com, mlxsw@mellanox.com
Subject: Re: [patch iproute2 1/2] tc: action: fix crash caused by incorrect
 *argv check
Message-ID: <20190723104732.69c18297@hermes.lan>
In-Reply-To: <20190723112538.10977-1-jiri@resnulli.us>
References: <20190723112538.10977-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jul 2019 13:25:37 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> From: Jiri Pirko <jiri@mellanox.com>
> 
> One cannot depend on *argv being null in case of no arg is left on the
> command line. For example in batch mode, this is not always true. Check
> argc instead to prevent crash.
> 
> Reported-by: Alex Kushnarov <alexanderk@mellanox.com>
> Fixes: fd8b3d2c1b9b ("actions: Add support for user cookies")
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  tc/m_action.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tc/m_action.c b/tc/m_action.c
> index ab6bc0ad28ff..0f9c3a27795d 100644
> --- a/tc/m_action.c
> +++ b/tc/m_action.c
> @@ -222,7 +222,7 @@ done0:
>  				goto bad_val;
>  			}
>  
> -			if (*argv && strcmp(*argv, "cookie") == 0) {
> +			if (argc && strcmp(*argv, "cookie") == 0) {
>  				size_t slen;
>  
>  				NEXT_ARG();

Ok, but we should also fix batch mode to null last argv

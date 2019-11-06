Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2208F11AC
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 10:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbfKFJEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 04:04:14 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43302 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbfKFJEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 04:04:14 -0500
Received: by mail-wr1-f68.google.com with SMTP id n1so24753869wra.10
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 01:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XKOHDKi98VSZNTCotACl4PvQRb1+JOOdSL1KGZqlJDg=;
        b=UisAp0JS/HoHwnQxqaYCpbmvMOn288EtR6mVTBMsQeyeeyzVc+4Qf2VTjlTdFN+rCR
         uKjua0JAyIr4m5NkgciYFm68mqmHeol7U210XdGX4ZlbT/qIYfmGNgq1bU7JyMc60k5N
         S82u7rnrzLEnQ3JsKFz7DIXK0XmbB+cHNFlXTNNxXUj4/OrNXLcZv/7sew4AfJi+qF7r
         L9pOvsIO08yNcyyixMp8GEh95/E3WSJqfc+Bm4ahSgBUIW8fdgpYEM15pGNdZ189nAfg
         urw6U8MiYptPSnrQsRRov3y7C6+xs24gkAR7y7GWYFGx6nORPkBuBpLNIlSxLyjgRKAd
         SiHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XKOHDKi98VSZNTCotACl4PvQRb1+JOOdSL1KGZqlJDg=;
        b=n9myTLgXcmn78somzH6/PKOVbOLZRKFOwJRczifDSE3Ag0r/F7JWr4eb8pCkXSn2gP
         /qqOaat8WuM2KKX8JsyXFkxze4vuc3OgDabT0rCUBUaGul9O/q5niKkqKkXZ5rj5kmzm
         HKqRvyIqkez26QYSKxPHPLUyfjACydVFtRcNIvM/lm7hewFRx2LnXDRAd1zQ8uIV/2Wg
         bWDbICHjQMvpcByxVwZnP+3i2XkmsvuBFngEtlZIgCE3rXw2frm+CUCFpsrIxlXoAjF6
         o3m9sjYBCopOnmuaSxIuhgds5ZGKpunP09uKYtboIHtzWKev+6guiRpY4YCBCX6HzBUR
         j2HA==
X-Gm-Message-State: APjAAAUnlEbT/wkwAahragm/bFBio8FBRhTw1FdCvKeTo6IJijKYIumi
        0rryc1blr8KZIwJ6NwdxIiYgGA==
X-Google-Smtp-Source: APXvYqzL+HPsxkITlEMkjn3RtDBegvQGwGLDu2zAflNTtvsAbz4FlOhUsUd0Aog7x6U5gPSiouHGdA==
X-Received: by 2002:adf:f489:: with SMTP id l9mr1459589wro.337.1573031051881;
        Wed, 06 Nov 2019 01:04:11 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id p12sm26251003wrm.62.2019.11.06.01.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 01:04:11 -0800 (PST)
Date:   Wed, 6 Nov 2019 10:04:10 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Subject: Re: [PATCH net-next] selftests: devlink: undo changes at the end of
 resource_test
Message-ID: <20191106090410.GG2112@nanopsycho>
References: <20191105212817.11158-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105212817.11158-1-jakub.kicinski@netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 05, 2019 at 10:28:17PM CET, jakub.kicinski@netronome.com wrote:
>The netdevsim object is reused by all the tests, but the resource
>tests puts it into a broken state (failed reload in a different
>namespace). Make sure it's fixed up at the end of that test
>otherwise subsequent tests fail.
>
>Fixes: b74c37fd35a2 ("selftests: netdevsim: add tests for devlink reload with resources")
>Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>

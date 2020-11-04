Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689FF2A6A11
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731175AbgKDQmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728999AbgKDQma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 11:42:30 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0697DC0613D3;
        Wed,  4 Nov 2020 08:42:30 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id 10so17741390pfp.5;
        Wed, 04 Nov 2020 08:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dco432F/StZ/3+Ux08tZ5ex29m6sc0CeFbawMQihOpA=;
        b=BKr6gEHP8Gu8if4iLjwmkU3/yea8B91wdyMAXxZi5Hy+//aAzYjyzOLELzbdQn4lNr
         N7Ts3cqqFYN/KX7uNKwqBlUTjBSqo3JrP1kbwBJd9l7hV6aRrCzelcuxGrfD+MPg5HYq
         honbXrUI3yPmOKobYn/3ID9w11do4AlPcpISIpfKwiyseEAIHYpjbDLwVQfZT3Z4UbzM
         +87OueonkMdLzfljz0mrdXXdt/OL1+DHDv6P3MhOCvJDSWdE2w17bVID8bklYH3NaRSx
         Q7+GO4MEWa0UNeqzna36vfVy0FGulndaFTI2qF5UXxrWiAj/Vpvw0PUCLyXULlOg8bkj
         zK1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dco432F/StZ/3+Ux08tZ5ex29m6sc0CeFbawMQihOpA=;
        b=S4DfgdF3DmRMjrXyuPyOIOxPrupwNHYgGNIUEUMAPSoPFV/cKSVM49Blt8o+3CAeje
         f/D389/PTx2TGtGaFE01BO+7/7HEJZKQFV1EgffQkLowxMF0/PtGZzHHeWBE/TZszYzd
         X3ISXpDqDnUEwWN0LrtMLNae6uwBcpeACz52XFx8Uf2GzRCFHU35ils1xaM2+CwAmhMX
         efk59ZF+r2o9DY2NmXBb89FTqug7UwOnfBxTPQ5ueoVqZxaktV5ELK4m3aDFE2hh3syY
         +6D1LSJOdSlgkdtbj5T1D0f+lgwSkRISaoGEQM/z3uUJjVbKTDXAgnjy4qy0rPGmxhOR
         DbUw==
X-Gm-Message-State: AOAM5318Vw/O21pZaZV5UJN2jMG7ixHAjNaGrSoU2L7dp4mYwaqnpbLE
        +++o5dkqdKOl5Am6s0krQkEuAgniQYw=
X-Google-Smtp-Source: ABdhPJzkV9+ajlDqMuhmMHY/j5X0pJB3CkTEzl4Bs2S/7TZpm27xitkz29SWNwSnUQ7WS8z3dYYYpw==
X-Received: by 2002:a17:90b:3882:: with SMTP id mu2mr5044499pjb.112.1604508149634;
        Wed, 04 Nov 2020 08:42:29 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id r8sm2838184pgl.57.2020.11.04.08.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 08:42:28 -0800 (PST)
Date:   Wed, 4 Nov 2020 08:42:26 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     min.li.xe@renesas.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] ptp: idt82p33: add adjphase support
Message-ID: <20201104164226.GC16105@hoboy.vegasvil.org>
References: <1604505709-5483-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1604505709-5483-1-git-send-email-min.li.xe@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 11:01:47AM -0500, min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> Add idt82p33_adjphase() to support PHC write phase mode.
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>

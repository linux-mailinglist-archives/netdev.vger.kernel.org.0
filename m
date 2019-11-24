Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8FF0108130
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 01:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfKXAKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 19:10:01 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33317 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbfKXAKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 19:10:00 -0500
Received: by mail-pl1-f194.google.com with SMTP id ay6so4828737plb.0
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 16:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=zCUnnZBOzb+U++eq90Ao/Y5fsVWb7S2HxKSyj5/jEoA=;
        b=aovH1C3UDxQMdEZVbFMDRQ+rUflh6XBPdcvQPFPjXeZFSAmpx6BeLpm3cIHaJFieTq
         fMwEWkmYnE9ACEwUu8CzABXeNSIhnNGWRbL0QwgrrNClfGF2YpEzejd6B1RI9vtnMdM4
         X4OP1UBS524jC96yRG9qoo3INFpM9hchmfHJxLrKSSJ/rfcNzcnckWdECXqUkE6rSqid
         JCK0FvhKSPPxAUJkRHhKhMQaVF8nKevtPkqSffIDFlmc2dCwG8HRfwUT/5neRWbnyxwP
         rRIjzUA6QKyx5/3goFDy3Tv6F0lA/s8GKgkiR3OzAPL1UI5r9jL5bP8kDc8xQmW8eb3Q
         NS8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zCUnnZBOzb+U++eq90Ao/Y5fsVWb7S2HxKSyj5/jEoA=;
        b=BJpjLbI+JPWjaV988IZ9z9zK/Irnkqi6QK6/NpCzMg5gRdFcb/dFjoGgwnOJg6VCo9
         KulDvskiKiIEjTYINvSNNtc0wjVkyVkChhD2uWqcqBOE1ed/nR8yi7fMT6tfRBfBT1yb
         Bf9doREoTWjR9rX0pHLGW1yfvXMLafVv/ejn8/9lLI4dVJ5tiAFvfRwxRMBgi1K3Tx0M
         5NamodcD+DFBFdYzukx1Eg8qO4aAFmtVM1yBdp7JXRhoCkJXzg+zuBVQRqv3s7pySUBc
         f4kRXc06STZBgQqSLN9cuIPFdz0n2+G/iKoDxNGQYpgB4NocKODzFzUzo+514N8kWx2k
         2L8Q==
X-Gm-Message-State: APjAAAWQ2gQMIswOkr3WYA5mR+xsALoP/GCtAmOvtzxBYPxvjKYiPi7P
        3s/TiJMpuLWtS5nSGLx2m0aD/Q==
X-Google-Smtp-Source: APXvYqxaDS2l1bodRaHkR+O3awfnjKsDfi+r178dG+l6XyiaLSqUHjFKoJ70Qjq3zfaZnMSYcsl5gg==
X-Received: by 2002:a17:90a:bb82:: with SMTP id v2mr28774989pjr.90.1574554199943;
        Sat, 23 Nov 2019 16:09:59 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id y1sm2843048pfq.138.2019.11.23.16.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 16:09:59 -0800 (PST)
Date:   Sat, 23 Nov 2019 16:09:53 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next 15/15] bnxt_en: Add support for devlink info
 command
Message-ID: <20191123160953.46630542@cakuba.netronome.com>
In-Reply-To: <CACKFLinKFLT5WJ__nNhwqOfOFO9jH9fOKmi9S_GSucecbmX0eA@mail.gmail.com>
References: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
        <1574497570-22102-16-git-send-email-michael.chan@broadcom.com>
        <20191123115506.2019cd08@cakuba.netronome.com>
        <CACKFLinKFLT5WJ__nNhwqOfOFO9jH9fOKmi9S_GSucecbmX0eA@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Nov 2019 12:15:39 -0800, Michael Chan wrote:
> On Sat, Nov 23, 2019 at 11:55 AM Jakub Kicinski wrote:
> > What's a board package? What HW people call a "module"? All devlink info
> > versions should be documented in devlink-info-versions.rst.
> >
> > What are the possible values here? Reporting free form strings read
> > from FW is going to be a tough sell. Probably worth dropping this one
> > if you want the rest merged for 5.5.
> 
> Sure, we can drop this one for now.  Do you want me to resend, or can
> you apply just the 1st 14 patches?

A resend would be better, the cover letter also needs updating.

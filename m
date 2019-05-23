Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCE5C283B0
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 18:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730987AbfEWQdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 12:33:10 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38409 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730790AbfEWQdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 12:33:10 -0400
Received: by mail-qk1-f196.google.com with SMTP id p26so1632862qkj.5
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 09:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=G45C3ziOsusCiIVcO34MSR2o6gPBZ97vvhrFHJV8k/g=;
        b=s+29o+BS6QblhLchMIrREjOxRRCRTWahBk3+IgQp8kxpJ3mBGrVfF7kyNgkUXXPio3
         VlcVb/rMf1YMciXYT2p1M017Pbd4m9sCKZLt1CdJRVk0uEIk4CitpAp612jV+PIpdL9Q
         JCQqtqhdgtK5OAX+uiJqfvDCFfRkBPFGFOe2PbRagdg3D04Zu2rqm7YVRbRicRXLCluV
         PTGzDsTAI7nap71uPNrQAeqFjoKY3bINCBdWAqJFmcnbJt0mdNmmpT60mWqH0o3pcBN7
         XL0osImD4GACeyhOYastQCEz2hdVNm20JZINJY6hPrtsdnQcDgBIx5ZDjMGC/9212rL4
         ByaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=G45C3ziOsusCiIVcO34MSR2o6gPBZ97vvhrFHJV8k/g=;
        b=HuCm+ersocVsq64IWs+jA3ulnotpK51gcvjw6SQEnjFIU41me9lSoeLD/sJrUtafRL
         uWp+kvNN9q2ARbZoY716YaQhkyrJJZCfHnFdvraSF1xRhvGo58L1v0nyzCXZVmKXybUd
         A/HUCLEqZdzoZ62rGMcs7b1vBDvK2aS6KLJtfWvNBEGkeKj1hYtZIx7DRnIm2cA9daHN
         9kc3F9/02Ut2d1+vvlP6ahYdcCp7aPOufEAXv7ZVfudOVeF83/yFf8qTIcuyaRO81kW6
         bhGl5Mlfq8vR6Geko6tcJLzTBlAukSMyYSmdLg6aDYQQ6Pf0e9g0hhjTcnEYsKmDYXwy
         ymiA==
X-Gm-Message-State: APjAAAVJcP4uviy2YEkQAOxI39/fgi1mKx4MQq8i/J7lEkwI+avs+foy
        vMQDFhAM9cH6H71C+OWreL3ZIw==
X-Google-Smtp-Source: APXvYqwfBlze5wFEaGpb9VoOz1xHZvETyFk41lL1iU8SE3HVIaIlT5aeqfbh7O1ercOvJ0fPpQB5nA==
X-Received: by 2002:a37:444f:: with SMTP id r76mr1506202qka.237.1558629189665;
        Thu, 23 May 2019 09:33:09 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t47sm14425025qtb.43.2019.05.23.09.33.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 23 May 2019 09:33:09 -0700 (PDT)
Date:   Thu, 23 May 2019 09:33:04 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Andy Gospodarek" <andy@greyhouse.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: Re: [PATCH v3 net-next 0/3] flow_offload: Re-add per-action
 statistics
Message-ID: <20190523093304.0e6230f2@cakuba.netronome.com>
In-Reply-To: <267b6dc6-b621-3278-58cf-562452d9450f@solarflare.com>
References: <9804a392-c9fd-8d03-7900-e01848044fea@solarflare.com>
        <20190522152001.436bed61@cakuba.netronome.com>
        <267b6dc6-b621-3278-58cf-562452d9450f@solarflare.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 17:21:49 +0100, Edward Cree wrote:
> On 22/05/2019 23:20, Jakub Kicinski wrote:
> > On Wed, 22 May 2019 22:37:16 +0100, Edward Cree wrote: =20
> >> * removed RFC tags =20
> > Why?  There is still no upstream user for this =20
> Well, patch #2 updates drivers to the changed API, which is kinda an
> =C2=A0"upstream user" if you squint... admittedly patch #1 is a bit dubio=
us
> =C2=A0in that regard;

Both 1 and 2 are dubious if you ask me.  Complexity added for no
upstream gain.  3 is a good patch, perhaps worth posting it separately
rather than keeping it hostage to the rest of the series? :)

Side note - it's not clear why open code the loop in every driver rather
than having flow_stats_update() handle the looping?

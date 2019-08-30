Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E864A2F10
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 07:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbfH3Fjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 01:39:43 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39740 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfH3Fjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 01:39:43 -0400
Received: by mail-wm1-f65.google.com with SMTP id n2so4638162wmk.4
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 22:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1wp+VbzCUI59xGci2FOifBql4duIgf397Nuhms2TWPw=;
        b=JXoo/8gXstErUb06GTBgBKo3rcv4zI2kdi/h0lc8RbMOAMNzDfThaJr4PFXLmrX3sK
         AkLbNdedylvq0GU3OcPOFuBY9Wc+pm8HHZBFhb8huSmSkEVZUXN44qggDKok0BAQMufK
         DsSYjhw23UyGTcrn6D1+ZJ3O+n2N2kYiQaFTvw12epR+aEfrQSA5BvDbIzSa0ahl0AwC
         XvlwOtwkxHnx4hGmJyzwFN70cRgEOyoF0rMi36AqUpDjOsI2kz2/lcWeiYS772N+jXGx
         I8dAgQ7/X5g3iBSq/ydYAwL+Z61l8jGIS4iv+1wduc3mxo012PmSiGYEEu+HnupJ00/U
         ta6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1wp+VbzCUI59xGci2FOifBql4duIgf397Nuhms2TWPw=;
        b=Ui/AFvkoRBmlZAFcNr655wNUBmaelzln0gpWOVF+39TPdCbr8BRvjoDRJ9c5XjraL9
         1vmjmFt11Fs5bi3Ax96vVdidAwLaKM/HfjwIvGMDovobff8/MPMU4VBsryEW3YHlr3Vf
         Vq3q5ZQdJ+b+9YQy4CpMG47YakKgSlY+A3adet03Aoj08r1BSkqRrE4L9EhyoZ0gJ9OY
         iE/v7hRZ9fGhdZ199aoyMXMfF+qN20Hv0bHMpKnDecIBCas7PssgIm9UXTP+prVHG859
         9JWTVXH4yJthwzIYnaKdwgzVoHC7G+MPQbrh067CVe2pD3nR0zar8YLn3nY5pX9LI8Qm
         gO6g==
X-Gm-Message-State: APjAAAXwoPYakHopnpbb71lqrNx1utGhXqZlJhz0Qgm2PIGnH0tViuWx
        KeSCd636YVYvA0aMcS5Epy9Jjg==
X-Google-Smtp-Source: APXvYqxFCvnEHwY5tbZHKnNs7cuHJXoQI8Z4jPbpqM6vDshHknFkniltgX66RuHTLBF+5UPAyk9+qA==
X-Received: by 2002:a1c:ca0c:: with SMTP id a12mr15418773wmg.71.1567143581424;
        Thu, 29 Aug 2019 22:39:41 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id r16sm8358227wrc.81.2019.08.29.22.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 22:39:40 -0700 (PDT)
Date:   Fri, 30 Aug 2019 07:39:40 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Miller <davem@davemloft.net>
Cc:     idosch@idosch.org, andrew@lunn.ch, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        allan.nielsen@microchip.com, ivecera@redhat.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190830053940.GL2312@nanopsycho>
References: <20190829175759.GA19471@splinter>
 <20190829182957.GA17530@lunn.ch>
 <20190829193613.GA23259@splinter>
 <20190829.151201.940681219080864052.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829.151201.940681219080864052.davem@davemloft.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Aug 30, 2019 at 12:12:01AM CEST, davem@davemloft.net wrote:
>From: Ido Schimmel <idosch@idosch.org>
>Date: Thu, 29 Aug 2019 22:36:13 +0300
>
>> I fully agree that we should make it easy for users to capture offloaded
>> traffic, which is why I suggested patching libpcap. Add a flag to
>> capable netdevs that tells libpcap that in order to capture all the
>> traffic from this interface it needs to add a tc filter with a trap
>> action. That way zero familiarity with tc is required from users.
>
>Why not just make setting promisc mode on the device do this rather than
>require all of this tc indirection nonsense?

Because the "promisc mode" would gain another meaning. Now how the
driver should guess which meaning the user ment when he setted it?
filter or trap?

That is very confusing. If the flag is the way to do this, let's
introduce another flag, like IFF_TRAPPING indicating that user wants
exactly this.


>
>That's the whole point of this conversation I thought?

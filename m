Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4AF727F967
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 08:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbgJAGVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 02:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgJAGVN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 02:21:13 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42EFAC061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 23:21:13 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id lo4so6275110ejb.8
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 23:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZQ5yOyC9J8jJsjdK51fsW+DJt0JyuCS+eOwBODDwVR4=;
        b=M00al8QQWjP1/zdBLA0EzIJT8lJEGIZ3RzwMbmcvA9Yj3qYE6255WLMAZD10Aa9ZCu
         e2q0EYAjIf9NE2j9roU969ZG2acQnCf22fmXMXLSMBUnLfzcQrPnTh3pU9OELVzvJLQZ
         qUmsTcyCJDf/7ISKLTidAmiJnzYm/rNMN1cxzSxPoYgo4bv6p/dIkkR3Vx92LhvGlI+9
         F4FMrgs+In8UK2VvoYHiQ/ULWw849NKV2buKNth7VDZxZm7YP0faaACJReL0hwhhv7tt
         a73KxAs7Slepv5mGAwRYrPEtQhRPw56yBShIEWSjwtfWfnh+Ctm/Uv0v17iwIVSAv5/n
         Y/qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZQ5yOyC9J8jJsjdK51fsW+DJt0JyuCS+eOwBODDwVR4=;
        b=nyJ5Ttd8b+yFgpHMHXZCrQXDPeiZuHaj5PEYX8wOheYgLdcQHN5wPFSIDZuWdKZW27
         eEF8pKymmglE9zK7S1BYEpWz/vCL6PN3fqjjlA5T4UE9tJLl+JuyanSSy2MUxmaeOmVh
         WEqj39vEpbJkw449QrYcJEjoYR3JUszP5aO+5QiBIWhyu90suS8cDWb0ZE9UbwU2mVIR
         oEPSNZw4wodgsrYFh8gZXOagJL18xjPgc0ZJ6RTDL6EkoX6tfUZE67g5/wivB0HsbvIs
         8/0GnyfKiLhdx/gSNfVX06UQm0NmRK08lPd0fl+bDfx52Mu8faueWAKoXF0uGrneAgU9
         SPbg==
X-Gm-Message-State: AOAM533osfk5euFHV8inaoFyAtfO/ta7swXGuqi5WFbl3DzJfw19H7sc
        87MQVnTkxDXlaElXFtuIgTs=
X-Google-Smtp-Source: ABdhPJw5Yg7aWu2fh4NMoEGCfKJ38Huyg8LRK4/Cq+uDQhto3SB9CU4EKrqpPs4vb6eay/szeLPvJw==
X-Received: by 2002:a17:906:30c7:: with SMTP id b7mr6574553ejb.7.1601533271917;
        Wed, 30 Sep 2020 23:21:11 -0700 (PDT)
Received: from fido.de.innominate.com (x59cc8a5a.dyn.telefonica.de. [89.204.138.90])
        by smtp.gmail.com with ESMTPSA id j15sm3324171ejs.5.2020.09.30.23.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 23:21:11 -0700 (PDT)
Date:   Thu, 1 Oct 2020 08:21:08 +0200
From:   Peter Vollmer <peter.vollmer@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Network Development <netdev@vger.kernel.org>
Subject: Re: dsa/mv88e6xxx: leaking packets on MV88E6341 switch
Message-ID: <20201001062107.GA2592@fido.de.innominate.com>
References: <CAGwvh_MAQWuKuhu5VuYjibmyN-FRxCXXhrQBRm34GShZPSN6Aw@mail.gmail.com>
 <20200930191956.GV3996795@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930191956.GV3996795@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 09:19:56PM +0200, Andrew Lunn wrote:
> > What would be the best way to debug this ? Is there a way to dump the
> > ATU MAC tables to see what's going on with the address learning ?
> 
> If you jump to net-next, and use
> 
> https://github.com/lunn/mv88e6xxx_dump
> 
> You can dump the full ATU from the switch.
> 
> bridge fdb show
> 
> can give you some idea what is going on, but it is less clear what is
> in the hardware and what is in software.

Thanks, I will try that.

  Peter



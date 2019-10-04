Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB0DFCC4CA
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 23:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387416AbfJDV2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 17:28:14 -0400
Received: from mail-qt1-f169.google.com ([209.85.160.169]:45229 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727548AbfJDV2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 17:28:13 -0400
Received: by mail-qt1-f169.google.com with SMTP id c21so10477097qtj.12
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 14:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=zZ3fNpy9I7rhpZUlfhnUCdf8+FwOnZrHfHR/lIbJHCg=;
        b=ue9YFD4p8k71SFP3dSJNN6isAvrVAO4GrV1EKUO0wAl9MlE2NOuP+jQhauPbSwAT5O
         tEJK+FvGYcurnecjmDCczwfC7ykAUHMsKJz6ezBdmC5x4QRF1YSeHSE3FlhtdB21yzLF
         EdhbRUVUZKSikZYKDkp+oDcD7DA0rCtgLVZWDtTRy/w7rMB10lHgDAtKCvBUjeNjR3dC
         g47dLjZ6t+TciZGB+yOoYBphTLtyUviA8PLoPEPzCDzIngcrIRJLGwD0/IBxPCLEeJC5
         8Bn5sg2Ss9YV7GvaMvmK6POwSlJoGi6vnMVhtERv4UxR2ogWR/XjngremjkvjtMuTLbi
         HIGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zZ3fNpy9I7rhpZUlfhnUCdf8+FwOnZrHfHR/lIbJHCg=;
        b=NXO+j/Ew8tMJcsXGvgsKFElmEVUm+u4wAguEWL8vdXSUwVdRc8iSTmQefVOj6odyYN
         T+Zfkgbgh5tkKjI7gnuJQ5vva6sijaug4wALDbPwNkSPRjXRBWYwfHrjog8/ocppCQao
         GTaFR4+xOGyO0Fc5CV8Hm4kE2PxSOfnGPv8a7x3THX7aKFr1ZYKXgcQJ7XIivZurvWmu
         TIt952UBzGCETujFE1hUS+svL1GXjBUYoYPgqqVmSR6JGB7gx7t5Eyn9vSm7melZheFN
         gv3namtq7QyTTqdMBWfSe5cLhv14V3GOoXbJWWvzdTaggMqpI/ItpIao1op2ePAPLc5Q
         49dw==
X-Gm-Message-State: APjAAAWiuun69hB2VBWej5hd7ZKgMKd05BGVt8mlw11oyhALEJJ3cfBw
        qnrpqPHXJyfpSpGr6O9gCVfFx5/fUXQ=
X-Google-Smtp-Source: APXvYqxhpXopsARpwM/3/+xln5U4XsNyLC7S6UFD8rqC05Y4wTzPU4S5Cs3Kzh0eUQHx+FJV3tkk2w==
X-Received: by 2002:a0c:fa49:: with SMTP id k9mr12426306qvo.72.1570224492879;
        Fri, 04 Oct 2019 14:28:12 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z6sm3332452qkf.125.2019.10.04.14.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 14:28:12 -0700 (PDT)
Date:   Fri, 4 Oct 2019 14:28:08 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        mlxsw@mellanox.com
Subject: Re: [patch net-next] net: devlink: don't ignore errors during
 dumpit
Message-ID: <20191004142808.3ce385dc@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191004095012.1287-1-jiri@resnulli.us>
References: <20191004095012.1287-1-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Oct 2019 11:50:12 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Currently, some dumpit function may end-up with error which is not
> -EMSGSIZE and this error is silently ignored. Use does not have clue
> that something wrong happened. Instead of silent ignore, propagate
> the error to user.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

I'd personally err on the side of caution and add this non-EMSGSIZE
handling to all the *_dumpit() helpers, even those which can only get 
a size error today, but I guess it's not super likely the errors will
change for the more static objects..

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

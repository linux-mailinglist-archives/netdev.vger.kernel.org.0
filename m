Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85BD12AEED2
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 11:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgKKKgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 05:36:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgKKKgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 05:36:05 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166E7C0613D1;
        Wed, 11 Nov 2020 02:36:05 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id 7so2115418ejm.0;
        Wed, 11 Nov 2020 02:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D2Ugx4D0J57kDynM1FB/co+swcqeET31GLiY2vmdTik=;
        b=sM3nglk9r5Az20iBquKX/2aTxunFf973kbnWZEzO63Nz84dOqf254nANdHzT1+RToH
         iaU85OnOGo3NuuQTrpMEp0z6CQkcTijqUc2AAvopfVQ5gAhNrSp6LhDtePtgf4luk8Bo
         o94IMatDrbTYtfC9WsJIoaJrC8EGe058CohKerCeSpHLXdaMNGyUI0rWJizKlS6meLPs
         BQy219Nv/tzkImyMqSYeNlguBpztf3OphAjFSDTYIOhr9e1qmq/wDxpJO4Vb552TePue
         1ylzgyAaSAcTv7Lp2fTVfyd7nlZiM8TWMH70u4la+dkFIpdf2a3TM+PXpLOOCmTJXWTG
         //qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D2Ugx4D0J57kDynM1FB/co+swcqeET31GLiY2vmdTik=;
        b=McDbWxcdApnHuNdVE98CJ6E6xh5x8rjK8EQT7Zc4eSlFl9JRHKoRcErk6M+DUImgWi
         pY8ddYageIKEG1YJ/+snQ5tX5k7zJaMny3dO2aQnlc77ZsOgsyjiceCddcblYC5RIE+o
         u89ZlvX3DfcczyEMogk5y/zFXVG/3zCKA5VheLZ/rMgPHu8g51c56xjqSyLVKBwHiTDD
         1pckGcV/K/+YyGO4Bmn92VBUbBREFfDOVS/2Jnn2RPYjdlzp8JdkUQWUcAyhJ6MMqnm7
         FhyPpD20leWmOHGpw3zb1Q4t2T0rU7NeWZi9F7iyUc4rBFeqoT7t9b8B3aWZEIr7oWj3
         pcFg==
X-Gm-Message-State: AOAM533CcgDEsMiIWNKiRQOcoK+E95IoiSen3o47nz6pQcnupkIkQ8+0
        XfqpQ1EJ2cT0QfXeGwh/67M=
X-Google-Smtp-Source: ABdhPJyylYZHj415vOO55tvEdKxmQV+TizDR2IOLgsBQXD6IxkpUVn9sjIAXRxIwNtFRlX+LXhfYqQ==
X-Received: by 2002:a17:906:c0c1:: with SMTP id bn1mr24199810ejb.454.1605090963790;
        Wed, 11 Nov 2020 02:36:03 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id j9sm707020edv.92.2020.11.11.02.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 02:36:02 -0800 (PST)
Date:   Wed, 11 Nov 2020 12:36:01 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: listen for
 SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign bridge neighbors
Message-ID: <20201111103601.67kqkaphgztoifzl@skbuf>
References: <20201108131953.2462644-1-olteanv@gmail.com>
 <20201108131953.2462644-4-olteanv@gmail.com>
 <CALW65jb+Njb3WkY-TUhsHh1YWEzfMcXoRAXshnT8ke02wc10Uw@mail.gmail.com>
 <20201108172355.5nwsw3ek5qg6z7yx@skbuf>
 <c35d48cd-a1ea-7867-a125-0f900e1e8808@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c35d48cd-a1ea-7867-a125-0f900e1e8808@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexandra,

On Wed, Nov 11, 2020 at 11:13:03AM +0100, Alexandra Winter wrote:
> On 08.11.20 18:23, Vladimir Oltean wrote:
> > On Sun, Nov 08, 2020 at 10:09:25PM +0800, DENG Qingfang wrote:
> >> Can it be turned off for switches that support SA learning from CPU?
> > 
> > Is there a good reason I would add another property per switch and not
> > just do it unconditionally?
> > 
> I have a similar concern for a future patch, where I want to turn on or off, whether the
> device driver listens to SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE for a certain interface.
> (Options will be: static MACs only, learning in the device or learning in bridge and notifications to device)
> What about 'bridge link set dev $netdev learning_sync on self' respectively the corresponding netlink message?

My understanding is that "learning_sync" is for pushing learnt addresses
from device to bridge, not from bridge to device.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C169F8AC7B
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 03:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbfHMBrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 21:47:01 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:35919 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfHMBrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 21:47:01 -0400
Received: by mail-pg1-f170.google.com with SMTP id l21so50387451pgm.3
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 18:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/aDKnOlx6ymWiySXM9BZIDKTmyNf0lDhH5ZraDlh70Y=;
        b=hVLHHtgzkSkGfs3UEHQ/sREPyZRPftGk8mBy28Y0hBCLz3VRjiz85FE51Yns83EaNC
         Lso3U3G6DNPbuWr0QUhifisjP1AdMtMXmXYqtYvC8DQAqWDvOj8Sjlxf1FPutOvyfQfm
         7Z95V62qYs7eL2o4BiofamArlXHkAY+GOLK+A1NkXWjKXItKCVab4M50shmSyiONiGI5
         PWuMf+PtPK14Iqy8NGKBhmVX6SRGW7A+dmReqTyfTEdO66QEP5Yb6d3onSkAR91N/U4K
         ZkXR8UVuBazf8sQ/2a9oTwko4UfZ1iQctwgNQrzXCzskNAuN/3AEuM+Zkytl0CEyzpnX
         M2bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/aDKnOlx6ymWiySXM9BZIDKTmyNf0lDhH5ZraDlh70Y=;
        b=dhd++lfyAyY20+EeGyOT6nmVqGfBujpzebhk7x2d9XRBkGjgpUffIxTOcfhcCMVw0a
         BShE8UEa7qFpblVNY0rSUNVgsn9etyziYXi3Z814aC4V6yhQZtt5LtKFP2fUWMdZ2/h7
         SOinUd7qWLId9+bax/d/kTle0f0LEmF6/y78E6UURkL09dgphNJ7K841lDGJYnY2l1dv
         dnvDsJlq2dTo0/um3Nl8GKvGIJ7BaNsBAkGuzeYJ0UJJEkDNKmTA/4c2wzV6okuFY48P
         YZopgpRXIRQ61pqYu+AmwXwuon2Tk+vHQrxnNXJY/NU55UpDbWZ0luM0uiESKLuA+ifq
         0qZg==
X-Gm-Message-State: APjAAAVvoON3nChNofCIIHmJ8MfSC0EV7Fha7WslHqa6HiaRn55W8Dbr
        aYqIvRV/fOeES9qx6EDDLHPeDOQT
X-Google-Smtp-Source: APXvYqxkNiV/hOTBHNi1z2v+lUbZJsKBilTHro3vC0DCRIHksW3DQaVpD7kMC5pAz3aqHkK+iMq9IQ==
X-Received: by 2002:a63:290:: with SMTP id 138mr29930978pgc.402.1565660820777;
        Mon, 12 Aug 2019 18:47:00 -0700 (PDT)
Received: from [172.27.227.188] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id fa14sm854076pjb.12.2019.08.12.18.46.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 18:46:59 -0700 (PDT)
Subject: Re: [patch net-next v3 0/3] net: devlink: Finish network namespace
 support
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, stephen@networkplumber.org, mlxsw@mellanox.com
References: <20190812134751.30838-1-jiri@resnulli.us>
 <bfb879be-a232-0ef1-1c40-3a9c8bcba8f8@gmail.com>
 <20190812181100.1cfd8b9d@cakuba.netronome.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a9fa6f7f-7981-6077-106d-fa2abfc7397c@gmail.com>
Date:   Mon, 12 Aug 2019 19:46:57 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190812181100.1cfd8b9d@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/12/19 7:11 PM, Jakub Kicinski wrote:
> If the devlink instance just disappeared - that'd be a very very strange
> thing. Only software objects disappear with the namespace. 
> Netdevices without ->rtnl_link_ops go back to init_net.

netdevsim still has rtnl_link_ops:

static struct rtnl_link_ops nsim_link_ops __read_mostly = {
        .kind           = DRV_NAME,
        .validate       = nsim_validate,
};

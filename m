Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFC9AF5A9
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 08:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfIKGRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 02:17:32 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:42174 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfIKGRc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 02:17:32 -0400
Received: by mail-wr1-f52.google.com with SMTP id q14so23027549wrm.9
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 23:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/cw4Cc71EcfhWiFZLoNQm0GR9ll/lW/HebF24EGQsTc=;
        b=0stCyYh/tPcrew6P1ezMp8fVrNO6NNEOS7I2bIk28dD7q6rEQ8dxFM3j3j/gEAhUSG
         w95ap2lqX3J8ADXnqgz8943q0KKbjgVoLU2AcAtSOkJ9zp0IYYT8T7z2d1zQ5j+GwbZD
         Hp7D2XVd4Oz2TCL0zcWRghZO4VU6F/Igy6DbjB60QcDk6qiBStYaj6ltNB0wRos4EXw9
         rdgtUgbRFGolOj7gxhFQWb3n3Xa6ZwLD+xC5UhoBUM+Ow0nTpgT1zxPJ+GpbDAOkdOlG
         cqv6YPKzDo7OZ+Kv+xr1+f4L68cA9dD2Ul0l4GTY0jeLzhogqpruwOsk/yqD1czVL/sb
         Avsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/cw4Cc71EcfhWiFZLoNQm0GR9ll/lW/HebF24EGQsTc=;
        b=bBHE0DDiQsIMpdv3xVk24+wk2SIx8+LTPcuGpeP/UTX8lJCqV17b9dBh7RonbGcn3P
         4UNyhkx4TpefDMwzTU3Y/5zLBffNyRpZBZUkPS2bBBBLRThxetgLIWmXCOgXk8xqBKa5
         NvDNBBD1kI1tAQ9Hz9K7UYTFsUsCu4d+pKnUsIPaQybzAM5DSo7VuJ9jY3MN5ihM775s
         WCU669bl9hXminW95Xm64op394qSvy5jwtSIqhSK4kYysAcWA24Khvgk6fNHIJUtNria
         pNcGKZrvsQU9+FFnK0UXtxxvCHhjC+FoYyCDRWSAmx2sOesqM15yiDQcKsjY1kGf2atZ
         ZkSQ==
X-Gm-Message-State: APjAAAVeRC5sut4A3z54J4ZYSo9VyzP879TzygaayAxIzt07HA5zzC7e
        ZgH7xe6qnixmzSdd1a3jY9gQ9w==
X-Google-Smtp-Source: APXvYqyAp+Yo0u/SSZXM9gpVIEBoMM/3L5Dg2/5FsKkSKg4M72/Hppvu5GKjFTtp89vzkbPk7quXaA==
X-Received: by 2002:a5d:6b49:: with SMTP id x9mr6747332wrw.80.1568182650345;
        Tue, 10 Sep 2019 23:17:30 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id j1sm25656543wrg.24.2019.09.10.23.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 23:17:30 -0700 (PDT)
Date:   Wed, 11 Sep 2019 08:17:29 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Tariq Toukan <tariqt@mellanox.com>, mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next v2 3/3] net: devlink: move reload fail
 indication to devlink core and expose to user
Message-ID: <20190911061729.GB2202@nanopsycho>
References: <20190907205400.14589-1-jiri@resnulli.us>
 <20190907205400.14589-4-jiri@resnulli.us>
 <20190908112534.GA27998@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190908112534.GA27998@splinter>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Sep 08, 2019 at 01:25:36PM CEST, idosch@mellanox.com wrote:
>On Sat, Sep 07, 2019 at 10:54:00PM +0200, Jiri Pirko wrote:
>> +bool devlink_is_reload_failed(struct devlink *devlink)
>
>Forgot to mention that this can be 'const'

ok.

>
>> +{
>> +	return devlink->reload_failed;
>> +}
>> +EXPORT_SYMBOL_GPL(devlink_is_reload_failed);

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E510D51D70
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 23:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729881AbfFXVya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 17:54:30 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36589 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbfFXVy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 17:54:29 -0400
Received: by mail-pl1-f195.google.com with SMTP id k8so7653375plt.3
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 14:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=KWnnG2dNqRnJ12yL7lEjP7FsPIGQ43JBn+8Iw4BIRM0=;
        b=BSH238FFBlBAMVAvyHmj7YuGmef75nKOpaKlI4+zXV5JczPbEGqGmC4rFRQWV53SF8
         bopLYVWT+Jtq87AFRXS1uO4R8D4Pt/AmUlvq336uWKTvTAS2ZOQ4mZTUkrY/lPIqjnDS
         c8pvZ/wRNUl4LvEpLPPLmBx+v/AiifIuqeDa3q4kmj709ivLnZii++tKahuW3pHc2R1q
         s6ME16GPNOLxsa1UP4nmW+M0fdkzWNaiibTZgNafXY5EwK4SnN7iqntAz8VYzr6B2Q1l
         D1mPEHmXsUD/wACiMTMIhlGcacVmCO3ImkWZAloitkLPRnVtDEC2fmcr3lUZcE2R72Eo
         kcxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=KWnnG2dNqRnJ12yL7lEjP7FsPIGQ43JBn+8Iw4BIRM0=;
        b=aGTzriugG/MUzv2g2zoj0NO6DYe0e2HazQtC+w6MJbQyzeypwBwVMw4GInDJjKbVRZ
         OX0hyDjactnk1K2sB9v9cKfhP4kwSWyR8kkfzunEv/jDRH/EyUgDCK76EU7z//Pvhofi
         jsmLjh3GWDQyeRNhUV/2NIr1za4t9MnXyX36stXElJc1hvhcIEP6YM7ST2nldd5I60X0
         PknBuSOh6eKmtHENfUyH5RnubSyM3a6NiQDxvxoQ0AubhHo0c6cfvP944Nlw61t7dGrO
         0xeKWZuk6THRgObD2zAa8g1+0GtHU4ZZi4bQ/SPEQw7513iuyH2JhqmjTBbX8okr80wF
         iMag==
X-Gm-Message-State: APjAAAVy/y61TJA1LhhB6ssO7Cx11/h7Ej+sEIPIXOzL3M6Y4AJmSO9F
        fHqR7I148XfCBIObsj2lIEqiznmbauo=
X-Google-Smtp-Source: APXvYqzesJ8g1OeuokUHuutrvePQpOyzUYtTFfc0hF26jeLYqhR/crsPH2W5ebFEIBOaBPeQhdeenA==
X-Received: by 2002:a17:902:76c3:: with SMTP id j3mr121728566plt.116.1561413269064;
        Mon, 24 Jun 2019 14:54:29 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id k197sm13692479pgc.22.2019.06.24.14.54.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 14:54:28 -0700 (PDT)
Subject: Re: [PATCH net-next 01/18] ionic: Add basic framework for IONIC
 Network device driver
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
References: <20190620202424.23215-1-snelson@pensando.io>
 <20190620202424.23215-2-snelson@pensando.io> <20190620212447.GJ31306@lunn.ch>
 <7f1fcda2-dce4-feb6-ec3a-c54bfb691e5d@pensando.io>
 <20190624130759.3d413c26@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <a438d451-7be8-4607-3f71-3a7ba968b9b8@pensando.io>
Date:   Mon, 24 Jun 2019 14:54:26 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190624130759.3d413c26@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/19 1:07 PM, Jakub Kicinski wrote:
> On Fri, 21 Jun 2019 15:13:31 -0700, Shannon Nelson wrote:
>>>> +#define DRV_VERSION		"0.11.0-k"
>>> DRV_VERSION is pretty useless. What you really want to know is the
>>> kernel git tree and commit. The big distributions might backport this
>>> version of the driver back to the old kernel with a million
>>> patches. At which point 0.11.0-k tells you nothing much.
>> Yes, any version numbering thing from the big distros is put into
>> question, but I find this number useful to me for tracking what has been
>> put into the upstream kernel.  This plus the full kernel version gives
>> me a pretty good idea of what I'm looking at.
> Still, we strongly encourage ditching the driver version.
> It encourages upstream first development model among other benefits.

< insert typical whining about internal vendor needs that have
    nothing to do with upstream practices :-) >

Sure.
sln


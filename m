Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698D73F434C
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 04:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234765AbhHWCIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 22:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234648AbhHWCIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 22:08:00 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4630AC061575
        for <netdev@vger.kernel.org>; Sun, 22 Aug 2021 19:07:18 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id n12so23776952edx.8
        for <netdev@vger.kernel.org>; Sun, 22 Aug 2021 19:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yrt6k+weNjsSrfFAZ15HSYZKMwh4EKIT6RXOFqosdj4=;
        b=jzxPUXJ0QTUG9LDfokKtd9IAHrs0JygSWfTptHl1lZFSCoV4uroU0V5SDoLIJvJNag
         rQ3o4XZxbk6gZ/aHUxW5d5u44DJFJomH1ToVBDnZ1FhMDpWuq1vlGBN6n4kkOGzcsHoW
         Bkqt0KfcJcrEbMgQYAMDuct5AldvlQilDVToKclkLOj5ogExZzf7GUrc8W3z2IAihGRQ
         dQYiiLVAsnSHv6CPqg4jj4bdCWkk3zqpVjtESQNVGHNC7ljeJ/TkCmx0K0hQzv8CHV7c
         g8DwqfZ0w/3NQ8CQRbf6oLXFOzVf1fU5iVirolNtEkJ4MRqqQdwacIr5d3sgmbPpgh4V
         rkrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yrt6k+weNjsSrfFAZ15HSYZKMwh4EKIT6RXOFqosdj4=;
        b=afyg5Yz6/sk7JJT36CRSPQrieYPetAvWfX+81gwYIf6y0I18JYeY92ZOPLoClDbJlK
         30HP9Z1BBWF/bNS7RNZWxcToZchEUrqfOZW9p3Q1ir9gXnGnARMLAzFP7dn1phMFYONp
         123acfvt3hBL+bnFH5+NV99Y007Hrc9BuO3sqhWpN5WJNKlyQEoRzLSThVLXeU7BcuiE
         /6Q3HOLfAgtIBcMOUlj/r6Qm7ISE8QdYBQ0VJYjnEh22TkSMXIjiAJPjxk1ziydnqJdN
         zcAIjqsXVLaz7fI8h6YpaUnwVf5NZL8AoEJFq/ZcT6iEaSWydcMU7g+AFjcbgBR/QK2g
         Ja3Q==
X-Gm-Message-State: AOAM533/fiacuNQVkXvjv60eU4Cs3OMb8cLroXmwOb4s+VqDmMsM0ZVo
        mBpHqV57wsdH1Jeza3lxi80=
X-Google-Smtp-Source: ABdhPJy6M2TSuiXqx5HaL7BrS70+fOnCetUzmd5JcFW4/Y/avie63dkh7n+azuEnUhpSs/fdeCZPEA==
X-Received: by 2002:aa7:cb13:: with SMTP id s19mr13418418edt.87.1629684436860;
        Sun, 22 Aug 2021 19:07:16 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id f5sm6435092ejj.45.2021.08.22.19.07.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 19:07:16 -0700 (PDT)
Date:   Mon, 23 Aug 2021 05:07:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: Re: [PATCH net-next] net: dsa: properly fall back to software
 bridging
Message-ID: <20210823020715.dn5il6vbwizkaqcs@skbuf>
References: <20210823015631.2286433-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823015631.2286433-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, I had other patches in my tree. Will send a v2 with clean context
for net-next.

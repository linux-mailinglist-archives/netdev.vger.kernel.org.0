Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28463B34F9
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730216AbfIPHAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:00:12 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55640 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbfIPHAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:00:12 -0400
Received: by mail-wm1-f67.google.com with SMTP id g207so8715212wmg.5
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 00:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vpFXrbyrbqNHyhvM4PdENLHPTK/LbEQ9hR7kEz1UzGM=;
        b=sWQpw/LqyQ8bbZxf5XbdkQVHcoKQmyPgNIGJjp3QLjV2r8iQyWSyyu4/DZZ4aQXCnX
         D94t7UDxSq2k15osX/+tk8UR5KkA0oGZfmRbqrI4ZTUtnaStjt0MbfRpAjSs7jNsx3EO
         bZichrEhLsMHMstWnJLXRt5iB7+jL9rglbWeadwgqcBFgt10ZwjPbn0iz0GDCSneXHw/
         rKSMqP7WxtJCWkma2OHui3LrENzP2I+JEtTkkhlelBxC92TWgFWwG7JzbvXHW0L1tfQW
         7OmbIkjMX6TRz8B5NbGy0+HtjXuYz5MGhTLBKmnmGPoJQlfW4KKHxgRbd2bq001bv/XE
         bLuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vpFXrbyrbqNHyhvM4PdENLHPTK/LbEQ9hR7kEz1UzGM=;
        b=rRLftOFKNWfuv8HB3tFYJ+xvDhBKEbVqBQgzpwCkPUSiSNZPe2SHVuAP/Ft6LDODRD
         6UY3BJRreh59dDrGKJPmcX9ANqyN+I3IdUtyjO0dwPjMLyMOuC1qRgo2bzEdYjRGBl0H
         U/13tuUFK27a3pbsasxMVM/dkoZhy7tCsvFQ9DausA4XiMDYIeIgDbUhdPr45uiUxaDr
         VlKeXkFkUaQPvxr0D//4fj66X32QMrZiJdqDZ9PtIMhU8dnLldWnKvhH2NaBI927H88z
         BT/XqjRNiDxgdkopVnVgI3gPsMg7pDPvCzaVSXR+Ee65VdZ1u96bVzeM9UrpuLsglNFt
         Q5WA==
X-Gm-Message-State: APjAAAVCpWhbxWZ9cXKYg3QbKfZ8Yg4BsL0Xk4GUaqsqZV7ILdbqIlfg
        RZ5UjrAKiARhHsaH9Tu3Y44b+w==
X-Google-Smtp-Source: APXvYqw91nL87jaJwZS1wgBUl1KqtshnbbbJzmQIQUit4a90qaTc1jalO6FFoW+58RKaKJ027B7wgw==
X-Received: by 2002:a1c:9c52:: with SMTP id f79mr12919084wme.89.1568617209897;
        Mon, 16 Sep 2019 00:00:09 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f143sm15046307wme.40.2019.09.16.00.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 00:00:09 -0700 (PDT)
Date:   Mon, 16 Sep 2019 09:00:08 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v2 1/3] mlxsw: spectrum_buffers: Prevent
 changing CPU port's configuration
Message-ID: <20190916070008.GI2286@nanopsycho.orion>
References: <20190916061750.26207-1-idosch@idosch.org>
 <20190916061750.26207-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916061750.26207-2-idosch@idosch.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Sep 16, 2019 at 08:17:48AM CEST, idosch@idosch.org wrote:
>From: Shalom Toledo <shalomt@mellanox.com>
>
>Next patch is going to register the CPU port with devlink, but only so
>that the CPU port's shared buffer configuration and occupancy could be
>queried.
>
>Prevent changing CPU port's shared buffer threshold and binding
>configuration.
>
>Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>

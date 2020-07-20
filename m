Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8DE6225C74
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 12:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbgGTKJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 06:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728001AbgGTKJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 06:09:56 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55658C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 03:09:56 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id f2so17201466wrp.7
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 03:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kldrPpNc8vb7+rLU+fHd+q9RYwbAXznoVk190kKnhq8=;
        b=mGTECUVsuX1tM4vvHvzLJYL47pLlpNOrLTORG/Qep+L0j8PtJ3RVNICUBgTw6trtkq
         XFIi4W04TQKDncgZYKlbf68R2iT74qSga9W6ydWyDD8s9dDfuzc7jGqE/aiMJZ7YcxSW
         jmrteAmJGb5ovtgB+N+JbUFCFdZqlF39EUKATKeETf/3VL8+mHp376AcE50y5plpG5Iv
         BEyJjKKe9kwCc5z/xFasKCrz+e9O2D39X0veTwrjM5SHZpo2rEd01bgZ3pdDkwmwD4Q7
         pJIT3yUXXNoHMPySbBFbJHHn3TC1skiTbwTmYSPzkCyvp8omvq2G5UO+HgoH2YNYU7XV
         mb8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kldrPpNc8vb7+rLU+fHd+q9RYwbAXznoVk190kKnhq8=;
        b=Lmq/2JyqPRp6maYDGEY3E5wII+e/iqdgz7E2oe/uEs2SFQqZwHk+xc0DZaZSiVcggO
         3KgXhTFtQhs9JJdclCMjjG8vKDdhLLt1aqMYsw9b17h8dk1y6dGKhtbFI8C5KrK0HImX
         I4M0frp54hfwx4UxT8ajAd0hoBxBD6GirSD21RYfWZ1lKYCJX2buAz3hzMxlx+O/NRDP
         u0D7s/UviPPJ+c3g4IpUa3xoC4SbHKIw4nfpuk5BgDVaonWjFbEq6oM6savtQhJCIds2
         NBk8xFvEF1/ogfSBH32kd8RdxPgXUQyOyHkKy2l7+Hh9ncNFFhxaftUYQizvYP+FEN+E
         tb7w==
X-Gm-Message-State: AOAM5313TIcoIL5eAW0sxoT1QSUURpo6wvYAnMqf+YVXkg57yZyalzrn
        FUkfWRZVHgKobi8QZTCeAofb7w==
X-Google-Smtp-Source: ABdhPJxeEHBY09cWAAVUr5nimuZgb4dYcJPKjDFF/9INcq8TlMhqZK4S2RQAlF0/YGL6laXOFpKmlw==
X-Received: by 2002:adf:bb14:: with SMTP id r20mr6974850wrg.366.1595239795028;
        Mon, 20 Jul 2020 03:09:55 -0700 (PDT)
Received: from localhost (ip-89-103-111-149.net.upcbroadband.cz. [89.103.111.149])
        by smtp.gmail.com with ESMTPSA id u16sm30734427wmn.11.2020.07.20.03.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 03:09:54 -0700 (PDT)
Date:   Mon, 20 Jul 2020 12:09:53 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kubakici@wp.pl>,
        Tom Herbert <tom@herbertland.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
Subject: Re: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to flash
 update
Message-ID: <20200720100953.GB2235@nanopsycho>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
 <20200717183541.797878-7-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200717183541.797878-7-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jul 17, 2020 at 08:35:41PM CEST, jacob.e.keller@intel.com wrote:
>A flash image may contain settings or device identifying information.
>When performing a flash update, these settings and information may
>conflict with contents already in the flash. Devices may handle this
>conflict in multiple ways.
>
>Add a new attribute to the devlink command,
>DEVLINK_ATTR_FLASH_UPDATE_OVERWRITE_MODE, which specifies how the device
>should handle these settings and fields.
>
>DEVLINK_FLASH_UPDATE_OVERWRITE_NOTHING, the default, requests that all
>settings and device identifiers within the current flash are kept. That
>is, no settings or fields will be overwritten. This is the expected
>behavior for most updates, and appears to be how all of the drivers are
>implemented today.
>
>DEVLINK_FLASH_UPDATE_OVERWRITE_SETTINGS, requests that the device
>overwrite any device settings in the flash section with the settings
>from the flash image, but to preserve identifiers such as the MAC
>address and serial identifier. This may be useful as a way to restore
>a device to known-good settings from a new flash image.
>
>DEVLINK_FLASH_UPDATE_OVERWRITE_EVERYTHING, requests that all content in
>the flash image be preserved over content of flash on the device. This
>mode requests the device to completely overwrite the flash section,
>possibly changing settings and device identifiers. The primary
>motivation is to support writing initial device identifiers during
>manufacturing. It is not expected to be necessary in normal end-user
>flash updates.
>
>For the ice driver, implement support for the overwrite mode by
>selecting the associated preservation level to request from firmware.
>
>For all other drivers that support flash update, require that the mode
>be DEVLINK_FLASH_UPDATE_OVERWRITE_NOTHING, which is the expected
>default.
>
>Update the documentation to explain the overwrite mode attribute.

This looks odd. You have a single image yet you somehow divide it
into "program" and "config" areas. We already have infra in place to
take care of this. See DEVLINK_ATTR_FLASH_UPDATE_COMPONENT.
You should have 2 components:
1) "program"
2) "config"

Then it is up to the user what he decides to flash.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54019192ACC
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 15:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgCYOI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 10:08:59 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55149 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbgCYOI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 10:08:58 -0400
Received: by mail-wm1-f67.google.com with SMTP id c81so2612735wmd.4
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 07:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sJBtuKiymDTJV9B+S4ieSl4Gb5RgJeYrNL5L1Eu2YcE=;
        b=PVDZ3uShhkBO+tyvjOkKKYo0tBPSsF82u2IW94pMg/dZU+Emzb82BFD7FPGRgmnX8H
         fx2ylAQ6zSZt08FiGvEp7osM6DA8EMjIDoUlJwx+hvRdQrqrXVV1lvrwp7CIblTd9PBb
         CoU0nwU9Rt2Smn8cJxaMP6R8hrYGauhefqtYoCMyWrMT4VpIu25xVeSQT1Zq5+zOux8q
         fFgp95CoUZIkeN7/GcrlICY9rshGUaAMrz8FIuOXMICMNSSJptKo9GNzxhJaNvHzk+5+
         qPLXvfzo7jkXJlgMp1qpc5eNP15Ik6fwRKcu1jrQKToCWEbCpT/k06GU7KZs0sSpuExC
         9h2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sJBtuKiymDTJV9B+S4ieSl4Gb5RgJeYrNL5L1Eu2YcE=;
        b=PTrwkDHfqdspdymVK9i9CV/cbON7DndFE2vreKOqW524Spq4dEGIPKz7UVaZZnX6WB
         WzSKxZ7Jx3SfW30USm1TrgfEbC/h8DJzajME9HaFDCBFLQgm/wVYjjOWHMmb9q8KJmr3
         JYKuuZ2khsRfcRk1S3NEAlAvXGbkfZ8eXvDV1DzJXKGujAaxlRjpPx5cDAvw8smEZ3g5
         RKw0VoKa9F1XX1nH+c9XZuKRxOwU59ExooGOzxBxx9vxdXc+uzxX/Re3HxSVmGvpFX8T
         xF9GwZyDGSDPkeBQfQGLJb2lj2mKfvTkKyh8CamW+dq12zZoS3ogrqX0cEzrT8/HAj5G
         layg==
X-Gm-Message-State: ANhLgQ1Ks/wl1aaPwz64124uHm9Z+zNlNmYF81iucnr71dPyA+etyH23
        0Kn3MwsFUqKLVI6a8Wl72/z+pg==
X-Google-Smtp-Source: ADFU+vuRvf4TQIm6pHp6kjYTmZ6W/HxH2fWXZ3hZdCtzeJj+3QsH8FMjIYaZJcvRUIzI+G5Fp/zWng==
X-Received: by 2002:a1c:4c1a:: with SMTP id z26mr3649701wmf.11.1585145336085;
        Wed, 25 Mar 2020 07:08:56 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id u13sm17820639wru.88.2020.03.25.07.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 07:08:55 -0700 (PDT)
Date:   Wed, 25 Mar 2020 15:08:54 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 05/10] devlink: extract snapshot id allocation to helper
 function
Message-ID: <20200325140854.GX11304@nanopsycho.orion>
References: <20200324223445.2077900-1-jacob.e.keller@intel.com>
 <20200324223445.2077900-6-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324223445.2077900-6-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Mar 24, 2020 at 11:34:40PM CET, jacob.e.keller@intel.com wrote:
>A future change is going to implement a new devlink command to request
>a snapshot on demand. As part of this, the logic for handling the
>snapshot ids will be refactored. To simplify the snapshot id allocation
>function, move it to a separate function prefixed by `__`. This helper
>function will assume the lock is held.
>
>While no other callers will exist, it simplifies refactoring the logic
>because there is no need to complicate the function with gotos to handle
>unlocking on failure.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>

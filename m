Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05DB1C4AE3
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 02:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbgEEAGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 20:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728258AbgEEAGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 20:06:42 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0360DC061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 17:06:41 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id f8so78207plt.2
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 17:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vUV5nGTsoQznCDI+5MIptHShSeOOp2WTJ5qCLRg1Mvk=;
        b=K/jDCz/0ARQlzavv7xQrjbfGY5MvHEzrfkpsYktY/Cd5pvAF2aTfCCQczqM6pwD9h5
         VLOmzVH3YJF9hLbrmWf0OxSalpnjSLDd/XlycYEzQrID0bLO0wRK+QqaUXZ2kMq64Yf/
         2YBg9+a6fO9xMq6+DZ8GjppUxxVhGXYaJuZii1LZl1dAKf1sgHRSJflS20Kc3VJnE2lo
         9v43+u/ugHDa3yLCH+aM9O9i2d4r3GCoVUxdfszO2k+7HKOefnNwum0x5aW5YzTl+5IO
         XfIuhZ7wTFeMIoFwMMWpXG+hpMVqEtEG6CD5SFSRoF6k5Ju+i+WFjJHIov6qQiF8POIz
         jN/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vUV5nGTsoQznCDI+5MIptHShSeOOp2WTJ5qCLRg1Mvk=;
        b=McC5+5BHLGtGOd/rNzLyAbOVuVtZ/D7lUb3Azd3Mm0u2yA0foLd0kSIRKzHIg70/3h
         TKZU4+EKtXU2S2CJJiRiXUfRFV/gu5PveNP+9vDkp7nomCiTmvn9o1gMT4MZ97IbjNtf
         AG5UAWYaqcUynVDkhuWGvfkdSct6kfNk2r0mu7OAEgzhaVh21UTJst1UPf5F+kR2ZtA6
         VJ+OIdiAD7m70KMVghrqIEPeEkVNdqrK3dW0tdlTQP048mIOedtKR3uAByoNYmfq0Nn3
         1I+0Spq/VwfEpe3k8RxCUoycz+TzYzeGdLmq1L3e0bOsgtuOgUjjitVsFV3d1wcd9eXn
         eRrA==
X-Gm-Message-State: AGi0PuYelNuSHv8Fcu1H7o/22WCXxr35Z8nQqvhy4SAH6z/6qlx4Nqsi
        LfS1M1JxHnR5NEEKPpKMOup4XA==
X-Google-Smtp-Source: APiQypJdo40fcYrMhZ2BwW2fhbYADmT+J28Da7TFAOxNLG4Istb1ih9pbTxYcsz26R7Y1izmEhJV3A==
X-Received: by 2002:a17:902:9042:: with SMTP id w2mr227984plz.127.1588637200388;
        Mon, 04 May 2020 17:06:40 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id e12sm185689pgv.16.2020.05.04.17.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 17:06:40 -0700 (PDT)
Date:   Mon, 4 May 2020 17:06:37 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Po Liu <Po.Liu@nxp.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vinicius.gomes@intel.com, vlad@buslov.dev,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, michael.chan@broadcom.com,
        vishal@chelsio.com, saeedm@mellanox.com, leon@kernel.org,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        kuba@kernel.org, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, pablo@netfilter.org,
        moshe@mellanox.com, m-karicheri2@ti.com,
        andre.guedes@linux.intel.com
Subject: Re: [v3,iproute2 1/2] iproute2:tc:action: add a gate control action
Message-ID: <20200504170637.3f723496@hermes.lan>
In-Reply-To: <20200503063251.10915-1-Po.Liu@nxp.com>
References: <20200501005318.21334-5-Po.Liu@nxp.com>
        <20200503063251.10915-1-Po.Liu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  3 May 2020 14:32:50 +0800
Po Liu <Po.Liu@nxp.com> wrote:

> +		print_string(PRINT_ANY, "gate state", "\tgate-state %-8s",

NAK
Space in a json tag is not valid.

Please run a dump command and feed it into JSON validation checker like Python.

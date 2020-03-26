Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8472193993
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 08:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgCZHZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 03:25:19 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37653 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgCZHZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 03:25:18 -0400
Received: by mail-wm1-f68.google.com with SMTP id d1so5810879wmb.2
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 00:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u4uWyCrgfB0UgIJbp2z4sBJk1eabu1/5RNsb+GsNVcQ=;
        b=RkdavdoHhkuk/F5jItIslxg2n3x2XYqcklh60/Jn32fLJKN6G2MNN0UsqdaxINCdQq
         3FXusrR/F2RaeYvq0T3Ct6H9e3x6MwENz7vWWsjmUrDgmjPm6ScmDqzbody1T/4uy7gw
         UwZQOxASn8jjahw50Maiaz1kGK5XOfErEXtsHnU2fKX/lua+KPCObnRrhRv4Z1BFNTW/
         Bo8YMxfMQ1ea1M5u4lwwUMJeCV7YPF6hup6EVLYnjrzwIj4S1qwq/3k4kqkJuKgMjill
         ciLSzm27Q+q5TLC1joW/PGqga9SC7mXwrjnqSX8wP3RXFddX9kxrvyp8XYpUA9jKHfHV
         7BhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u4uWyCrgfB0UgIJbp2z4sBJk1eabu1/5RNsb+GsNVcQ=;
        b=s1R9+mIzexL0/ciblp9Iu1SRhOoWwJVs3LMhTHgJnab/r/HTy8OfLB0ds2BRxVNYf+
         XSsTYpCM33raw1ot43yVV6Qu7dHfV82QVaHWeOGCClbWtIDrnpociTP0igEcJlSNX8It
         86tSdxDGi92dkz1okcT6dwAP7I4H8Unv+uzT33jZI7XIVC+AFh03sfMrqkV/s23q1LXJ
         vyjj7nXPJc6EO/p1DUAPt8Tl72P7qlMPBRYK87WsR7OpkimUGdUvoAuTKcL/HhNF5amA
         D1JJ5+D7BZjIA8J6IyoXs6BqK4CopdAcQmBeXRAVTrb16jBW0oVpZxDod5eX8xHz15yv
         aHtQ==
X-Gm-Message-State: ANhLgQ2MftJ8jtTQNgnhoTVguJ7+IjsCmC4Azd7zIualdaxojcrw3Aja
        mDjF0yxvNCJ1BQqE7L+ph9iUsg==
X-Google-Smtp-Source: ADFU+vvHMus1s49P+0IXcWExe9t5mSnzHdi5QfyS8IwlD9ik9DE50zyjP2BoUS2E7n7rk3IiwFyWdA==
X-Received: by 2002:a05:600c:410f:: with SMTP id j15mr1631589wmi.95.1585207516008;
        Thu, 26 Mar 2020 00:25:16 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id d124sm2255137wmd.37.2020.03.26.00.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 00:25:15 -0700 (PDT)
Date:   Thu, 26 Mar 2020 08:25:14 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next v2 06/11] devlink: extract snapshot id allocation to
 helper function
Message-ID: <20200326072514.GI11304@nanopsycho.orion>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
 <20200326035157.2211090-7-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326035157.2211090-7-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 04:51:52AM CET, jacob.e.keller@intel.com wrote:
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

I already provided reviewed by tag for this. Please carry those around.

Reviewed-by: Jiri Pirko <jiri@mellanox.com>

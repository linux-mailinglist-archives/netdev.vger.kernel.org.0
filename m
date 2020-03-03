Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65CBB177326
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 10:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgCCJxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 04:53:22 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41197 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbgCCJxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 04:53:22 -0500
Received: by mail-wr1-f67.google.com with SMTP id v4so3476406wrs.8
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 01:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pqBcDErKzkwtXUpEsQoyK+2L6qloiSPILUyInb9tEPY=;
        b=kKdJTJJ/cKYUB9/yjjpGLVDu6M6OL/jjWZG66/8krjRER4a75MEICr64hjEz9Dv50e
         HrLxPGolT5EGvBwCK24hNJCYiAOmZwzdzl0AGTWuyssZWOrWhcEl5oQP7FJmOnLXnPnm
         RGEiNSfyfGts8C5Vt5zuaiHxzeLfH4wKofC2fOsfmwQazbWl07La6H2g8ya8Mv5qpbuZ
         nbMVDPET7jt/uRwj9ygaOK6DgWEWAA1ocRWL+kJNDVJPEeK6fL4PAXo6bo+HovjTHHpV
         92RLCWlLK4kSVyf6csqPAYlEJqTkxFyv/FLkDKstsfoaxxYIcrI/rtnOMh2KznWJswsu
         ez+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pqBcDErKzkwtXUpEsQoyK+2L6qloiSPILUyInb9tEPY=;
        b=D/77xEbyj6VhZwfpnzXE0lB2tzrCWFmWlIFecEVtLDEdw/i1E7fssVmiA32maHNr0J
         8CTHzfTgXgkuRoW/kK0LKiVYwcduCbK0IVVMRs9wsXO91eugHk3IQcMDbLyyHApIo30P
         AcmWEHmm71k7RB8mt7z1A9I+LxA0M7IAaw8C/zLwVsvRFkfKPBKkfaEt/vzcyFvM9DBx
         0iRuZJhC6qvScGBv1sPFRsM/J+eY+1lI2nff6HuRxgRmB9WIqu2yDJs2YPPI/CsjN/ib
         mE+7B7qOfoMbWAuqGpxspZBxF3iat7XA1xtPh4GmMqtibCS/5qs3TTp99nWrO2YU5GMB
         xBPg==
X-Gm-Message-State: ANhLgQ3qKao9XKRQkUZKxBrn/oaT88ErbzjdNtKxIlC/ueOi7898C4Y/
        GqXUGaGLmzzTaSxlxSUCDb95Eg==
X-Google-Smtp-Source: ADFU+vvWRUHecJpVf8BfBcxVvjbVpJmFkZTTC/XwiOHNIjjXZTE7yT6oRZ9c5beC9YzbsoMMT3E0kg==
X-Received: by 2002:adf:fa50:: with SMTP id y16mr4588703wrr.79.1583229200572;
        Tue, 03 Mar 2020 01:53:20 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id y10sm2852153wma.26.2020.03.03.01.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 01:53:20 -0800 (PST)
Date:   Tue, 3 Mar 2020 10:53:19 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net 12/16] team: add missing attribute validation for
 array index
Message-ID: <20200303095319.GE2178@nanopsycho>
References: <20200303050526.4088735-1-kuba@kernel.org>
 <20200303050526.4088735-13-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303050526.4088735-13-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Mar 03, 2020 at 06:05:22AM CET, kuba@kernel.org wrote:
>Add missing attribute validation for TEAM_ATTR_OPTION_ARRAY_INDEX
>to the netlink policy.
>
>Fixes: b13033262d24 ("team: introduce array options")
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>

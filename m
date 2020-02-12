Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 749E515ADEB
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 18:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbgBLRA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 12:00:27 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:54905 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbgBLRA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 12:00:27 -0500
Received: by mail-pj1-f68.google.com with SMTP id dw13so1126073pjb.4
        for <netdev@vger.kernel.org>; Wed, 12 Feb 2020 09:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VzHWDOof07WBoTbsUagoJgmuhY3y5Os9XY61/G67Xyc=;
        b=I1W1jVE4vS1hUxEdxLjHCxqJENbzeF+TB2HP/zDO90G1c5ekxVxfvX6pc6lXLQz67s
         4AbuzV5OMF0bZpFsQnwGQvr+Gft6M8paZb3ZsigUxX8a95aYZav+Y90T98cY60R+U/er
         TWX9Em6WDlJ9SNTV9EX0DAE2h89tBL9MHvHWwLHfYIkFAeB2hfB6zgkVdk6jb4hzKn39
         A9WiCJNfEigCuWe22uddQI5RHd9E6zAEe9jyjXuPyKkIz8+Pzm4soECtqq9yObbbkiNM
         aG/2uVGkJc4lIz4xaemB7uEni5tqZNxCN+PsSUh5ZiSJHMpO4Is6KYaPR/tTwZN2faYJ
         ywbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=VzHWDOof07WBoTbsUagoJgmuhY3y5Os9XY61/G67Xyc=;
        b=IisqkoMSc6VUS8cluV/Hdzceb5VpCORNvJwSkLTR6vr9TCy0Stj9TkTtk7BnOiyyHO
         cZbJftu+CeQYalabNkcdI04TL0dVv2vfDRzmDS14+GLjOiAdsQHCJ9Xseyw6xI19fcNM
         b88IouqzhyoQLTH58u8u4AoeN24840e4T5/3l5Oy7J4Xn4YQQ46fv9SPzZErNV1iypwz
         yM2pzOtnq+0NvivDHEOBglUrE9C/3gQirL8gZjt7YrnUaPeu4y8gl90/NIczbfKflzfA
         fQTqQCqzr1R4AaKpI5Y21j/VSyytadiP5k1RTP+SCBE0A34p4a0zNXyDTlU0XMGelWJx
         Ggcg==
X-Gm-Message-State: APjAAAWK2ySOZM/D0FIk6jULuhj9ha21jIaP9v/4fSHN8ZAEfYSATzuI
        istK65GpOq3mqZrSyTfXunBFr1iF
X-Google-Smtp-Source: APXvYqyAm87OPQqfgJm86+GH22476hSMEcTCPIjTCgNc205qzv80c85FdRmFNorckCD+R6JH1MCMjg==
X-Received: by 2002:a17:90a:f17:: with SMTP id 23mr16846pjy.84.1581526826850;
        Wed, 12 Feb 2020 09:00:26 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id x12sm1601029pfr.47.2020.02.12.09.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 09:00:25 -0800 (PST)
Date:   Wed, 12 Feb 2020 09:00:23 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [v2] ptp_qoriq: add initialization message
Message-ID: <20200212170023.GB1758@localhost>
References: <20200212101916.27085-1-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200212101916.27085-1-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 06:19:16PM +0800, Yangbo Lu wrote:
> - The ptp_qoriq driver users don't have to install an ethtool to
>   check the PTP clock index for using. Or don't have to check which
>   /sys/class/ptp/ptpX is PTP QorIQ clock.

You just stated the reason why your new pr_info() is more spam in the
kernel log.  So, NAK on this patch.

Sorry,
Richard

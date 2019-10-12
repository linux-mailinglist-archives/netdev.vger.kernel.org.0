Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 561A9D518A
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 20:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729280AbfJLSJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 14:09:00 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:32813 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728636AbfJLSJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 14:09:00 -0400
Received: by mail-pg1-f195.google.com with SMTP id i76so7659931pgc.0
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 11:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QuiDiQV6zWuTckoeUzNeF6DC2ybuOpZw11FEpf74/WY=;
        b=Ku5jaExXNyQ9Kl0v25TRbhncuqB44/pst1RT59tImkN/Ll88qIfkQBsPffCRj4tKFk
         kZYXYeVMkG7xf91M4WB47k4Fh0UiISKYZEUuAMSC//CyshQgZB9MEvqWsCRaAlZGnLu4
         N/nW5OXAvez6rSOiX3Am1N16NlqXcHKnufb9QIGzlqdyXX1Y/jikwDAsI168XBfzq0Lq
         sjdGA6gqwCeNf9Ht+Ai+AO6D1O3rie9QsQaYIUog4Eg6dze58zl7imq1PcvBI0X5V93I
         Mv7PbaL8NFYv4SGUM8yYOgQAi35TsjJq6a8DLDPeCRJBKzPoNwN5q+BmFhl0zRF29R7q
         PKkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QuiDiQV6zWuTckoeUzNeF6DC2ybuOpZw11FEpf74/WY=;
        b=F1A8Nb5GC0K91oAdaCuVDbv0NTjlu9padH2htfJaYPOTN71w6XkRXnR2wQAz3dkalo
         JkioBK2198JDzL2yydexR6h1W7ar3OaJ/LJKQQyDaS70XF5/jITnyaSlwxNgfGj1FlwT
         Vh7hzcWmA6c0/14UcCoJI7XpEAlrpLs/jk4HtheUOgmWzJCt1AoAp280/1PTeUGY98nB
         7t0TvT3L82gNEgjL2cs1FIDHj+MAUySxPKhxcAvGXgT+1TzcsTBirUFYCFEPVqHE/yFk
         cgwohmVoP2ldO01SWm8+29K95CyqJQ+EVl6Fgxh3DvMaQHQwyhzEhKI9boqDvChI4A5D
         WjUw==
X-Gm-Message-State: APjAAAVeTSNAmUiWFTqscRt5mRe/W43UrmJEhNE3vGC2inHolnvtyfWl
        LyO34r1DXcaz5NTMm0YU1BbJVjky
X-Google-Smtp-Source: APXvYqxMRRDwHGY+YMQLfntq8GcJZQhaST6LU4uGU8SUKDtmLe3jbuE5G1l0noruWom9zeZUkYJShg==
X-Received: by 2002:a62:1953:: with SMTP id 80mr23635170pfz.168.1570903739881;
        Sat, 12 Oct 2019 11:08:59 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id k6sm4337144pfg.162.2019.10.12.11.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 11:08:58 -0700 (PDT)
Date:   Sat, 12 Oct 2019 11:08:56 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org,
        Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Christopher Hall <christopher.s.hall@intel.com>
Subject: Re: [net-next v3 2/7] net: reject PTP periodic output requests with
 unsupported flags
Message-ID: <20191012180856.GC3165@localhost>
References: <20190926181109.4871-1-jacob.e.keller@intel.com>
 <20190926181109.4871-3-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926181109.4871-3-jacob.e.keller@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 11:11:04AM -0700, Jacob Keller wrote:
> Commit 823eb2a3c4c7 ("PTP: add support for one-shot output") introduced
> a new flag for the PTP periodic output request ioctl. This flag is not
> currently supported by any driver.
> 
> Fix all drivers which implement the periodic output request ioctl to
> explicitly reject any request with flags they do not understand. This
> ensures that the driver does not accidentally misinterpret the
> PTP_PEROUT_ONE_SHOT flag, or any new flag introduced in the future.
> 
> This is important for forward compatibility: if a new flag is
> introduced, the driver should reject requests to enable the flag until
> the driver has actually been modified to support the flag in question.
> 
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Felipe Balbi <felipe.balbi@linux.intel.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Christopher Hall <christopher.s.hall@intel.com>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Richard Cochran <richardcochran@gmail.com>

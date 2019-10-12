Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42045D519C
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 20:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729279AbfJLS3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 14:29:00 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41933 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727423AbfJLS3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 14:29:00 -0400
Received: by mail-pf1-f193.google.com with SMTP id q7so7985994pfh.8
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 11:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Z4e8uk0IpJRuBvJTEmmHHew7MLg0EsYSSDTpP3A/9+4=;
        b=iBunLz7JASh89AWFZIk7A5IHq7gsj6GjImlSoTPCT3vOBudn43qAGTACNLrrT5q6dv
         SJS1eOyqGr3up6VzVDntE219I1IQKZm7yoxtu15mT6/U8rIBxS1Wy6MmWDINzsjYCzPe
         aRUwZ+hsdLNuqZI70NF+RP2bJtCn3/stnovTf2YWv6hzoHnLYwXbQSb5GRqM8Ca014Lp
         vPzd0b4h625wXdBUF1ujxR5qZaWRPF2qIAl4PDJuPsS0kqt8AeeoCErGOBoSlk7ng8HY
         of799EiVo7DrG9PE2vBgnYB6z0/ybj9JCCO9s/Z7eUgfbn5f0krql3ZeaZWI2sl/Xd18
         Jdtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Z4e8uk0IpJRuBvJTEmmHHew7MLg0EsYSSDTpP3A/9+4=;
        b=RxrHtb0Xv0AXxbjvqqQntWmGxFOhOUktxqkOC8U1AovNPg3wk4UURtqbOfRumNT3m9
         509vOsKHm0+s6aLGW2BuzeQjr+higwZl8RtYwkgCzEJgyz59BzCEGj2Z9sxUjpsV6HCj
         fKv6VShm9G+9POH0VzGyIW9sILnF4gwGqN/sb0OFJZda/Kceuy25IrTT+zcGoGpqJwsi
         T7UGA/IklS1MdTWcjDy2UWQSHrhWKKxkekrn1tL9UbpMfZ/h6bSfYJItSOCJhUK+05ex
         rupOtZvIPv/XJKAfBNvr2635/oItTfP3g0LOShFHqFT8csV6CpEY8hsVCwjtG7oqC+Oe
         PTUQ==
X-Gm-Message-State: APjAAAXtlM2yp75G69pNX6NkZts+7HMstfwukAxOxcx0Jv37UmRjNHsm
        yK9vla7h8zY1AND48I7k13s=
X-Google-Smtp-Source: APXvYqwgEMPBAKLKkFmQRtfgnKkLQ/Pr0iqazWs7tkIKlVJoQBvtK8C38EfeWfafmOqSL/+dzgE0Vw==
X-Received: by 2002:aa7:9f47:: with SMTP id h7mr23836748pfr.44.1570904939557;
        Sat, 12 Oct 2019 11:28:59 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id b4sm9661956pju.16.2019.10.12.11.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 11:28:58 -0700 (PDT)
Date:   Sat, 12 Oct 2019 11:28:56 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org,
        Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>,
        Stefan =?iso-8859-1?Q?S=F8rensen?= 
        <stefan.sorensen@spectralink.com>
Subject: Re: [net-next v3 4/7] dp83640: reject unsupported external timestamp
 flags
Message-ID: <20191012182856.GE3165@localhost>
References: <20190926181109.4871-1-jacob.e.keller@intel.com>
 <20190926181109.4871-5-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190926181109.4871-5-jacob.e.keller@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 11:11:06AM -0700, Jacob Keller wrote:
> Fix the dp83640 PTP support to explicitly reject any future flags that
> get added to the external timestamp request ioctl.
> 
> In order to maintain currently functioning code, this patch accepts all
> three current flags. This is because the PTP_RISING_EDGE and
> PTP_FALLING_EDGE flags have unclear semantics and each driver seems to
> have interpreted them slightly differently.

This driver has:

  flags                                                 Meaning                   
  ----------------------------------------------------  -------------------------- 
  PTP_ENABLE_FEATURE                                    Time stamp rising edge
  PTP_ENABLE_FEATURE|PTP_RISING_EDGE                    Time stamp rising edge
  PTP_ENABLE_FEATURE|PTP_FALLING_EDGE                   Time stamp falling edge
  PTP_ENABLE_FEATURE|PTP_RISING_EDGE|PTP_FALLING_EDGE   Time stamp falling edge
 
> Cc: Stefan Sørensen <stefan.sorensen@spectralink.com>
> Cc: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Richard Cochran <richardcochran@gmail.com>

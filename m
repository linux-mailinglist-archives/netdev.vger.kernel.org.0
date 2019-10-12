Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3F8CD51A9
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 20:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbfJLSgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 14:36:36 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:38991 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729418AbfJLSgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 14:36:36 -0400
Received: by mail-pl1-f193.google.com with SMTP id s17so6027830plp.6
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 11:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=awS0hdb260yU0YkzCeDNHWedy6Tr1IDerWF3RmG7BWI=;
        b=XKcvhQ3O5u7U6dds/rkN0xc9BCq4KaCQfdfaYu0O6jK8WMgujEnYM4vURRao/7nWcg
         vluX3zDrqNu2dG4zU17j3dNDrsILjvum3u0A0ZeWFprxJGEzfg+qrsYidaX8tvIARfrd
         FfbngAtNAkhSdJFaK9vARAy3HRKEnQo9YKCQuCbClhz2k8XSw5w31gREeCiBjUHAgJpM
         k0O9yuce3VW9XTwFatJMge+vsXIyGkc+2ny8MqaXFRLOFvRdhm7z/wyw8kNSdTcGD9cs
         81wQtwGLvHrjkf8AkcHdyyUONDSHlpqrA5XZtYkuXaqgN5V1jgHkB6FnyGQXrSzXiNWo
         ozMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=awS0hdb260yU0YkzCeDNHWedy6Tr1IDerWF3RmG7BWI=;
        b=aoOgJYVr1M77XZSYcm/y+jgFyghbbRV3HUfA+bLRRVEM7p/Kejhr2lXL8rA6u8aT87
         WW7SMZ97JkXPDkFIbWjSSDq1OoxTQt+Z/PwPiP3o9roZ5AsTpSP05q1Pm+TsvpNoW/MT
         AVR7wJ7VhWmOC9QT6+BbfoS+MPT5YBUsycOHUKRjP7jME+Y1ie3SXZ/YbbYOe0WTIU9a
         F6VcSkON7HGijluh82IvQ51SWO3L/0h2xFCChwBfu5ZTVeIWFffq8urUsZ8Id37t7kBw
         xXfsPk6mIqviuom4VdHdv4EBVuSwDBvJmYB7LdBZb9HQs+Z7hQxtG5E/DVf2LS9uE86B
         99FQ==
X-Gm-Message-State: APjAAAUUYioCQbGlFyibcTaJ5w+e8XUpiGLheqzFDYqfeN1sbpshqThf
        /kNMZJmK8/dHd9/uRsZ3GfM=
X-Google-Smtp-Source: APXvYqyV29gIc4I0YbQIa0W8bKMTNTDS4z28ICFwPt8HL54wZ2aVyBO536qH/w5s7LeCKzOWCbi3fg==
X-Received: by 2002:a17:902:8ecb:: with SMTP id x11mr21694380plo.234.1570905395546;
        Sat, 12 Oct 2019 11:36:35 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id q132sm12873341pfq.16.2019.10.12.11.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 11:36:34 -0700 (PDT)
Date:   Sat, 12 Oct 2019 11:36:32 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org,
        Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>,
        Feras Daoud <ferasda@mellanox.com>,
        Eugenia Emantayev <eugenia@mellanox.com>
Subject: Re: [net-next v3 6/7] mlx5: reject unsupported external timestamp
 flags
Message-ID: <20191012183632.GG3165@localhost>
References: <20190926181109.4871-1-jacob.e.keller@intel.com>
 <20190926181109.4871-7-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926181109.4871-7-jacob.e.keller@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 11:11:08AM -0700, Jacob Keller wrote:
> Fix the mlx5 core PTP support to explicitly reject any future flags that
> get added to the external timestamp request ioctl.
> 
> In order to maintain currently functioning code, this patch accepts all
> three current flags. This is because the PTP_RISING_EDGE and
> PTP_FALLING_EDGE flags have unclear semantics and each driver seems to
> have interpreted them slightly differently.

I'm not 100% sure what this driver does, but if I'm not wrong it
follows the dp83640:

  flags                                                 Meaning
  ----------------------------------------------------  --------------------------
  PTP_ENABLE_FEATURE                                    Time stamp rising edge
  PTP_ENABLE_FEATURE|PTP_RISING_EDGE                    Time stamp rising edge
  PTP_ENABLE_FEATURE|PTP_FALLING_EDGE                   Time stamp falling edge
  PTP_ENABLE_FEATURE|PTP_RISING_EDGE|PTP_FALLING_EDGE   Time stamp falling edge

> Cc: Feras Daoud <ferasda@mellanox.com>
> Cc: Eugenia Emantayev <eugenia@mellanox.com>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Richard Cochran <richardcochran@gmail.com>

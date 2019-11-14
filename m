Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19CCCFCED0
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 20:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfKNTiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 14:38:10 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34887 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfKNTiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 14:38:10 -0500
Received: by mail-pf1-f193.google.com with SMTP id q13so4987000pff.2
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 11:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ap64xGuQZSeSJr3SeCeY6K4NgvAXKseMGFJ4MAefoZU=;
        b=QgwBx3q2RTBjWCypRcjCAiybB56HkofV5Nj1iE9QMeSXuVZIxJ+z3gm7Y/URXm5FOS
         fbACu9mpPK2TnPOkWPcKN+XIiKMc+6VG+rEF2hYSzm49c4rXDwGQk8ws0Xlx3FWHU9gh
         r6rmbHRzWgmrY+tlbMVTqLVnBUKB20s5qpIclXh+7s2ABK7LVaV80ThNAxt9Fc2DR8iX
         2fQAz1iddqwSCmjKi+Ida7Z4G2ptjMq8Yg/kmDfxEt9dwSmbTsX+TkQQPcWC7QGTWFfK
         RP066OY9+HlynlHFy8f8uqT63N6fA3esx4iTbApW5V9aiqGfGlo2mazpbBsrbBNErbXJ
         9PCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ap64xGuQZSeSJr3SeCeY6K4NgvAXKseMGFJ4MAefoZU=;
        b=iIXoIrjqaolqLTF01GW62AFtsk9RVQwNugyjrkqok030dE00s2d6dIN809MyhHAA81
         3q6SFChmqaAFOEjlg2GLJ4Cur10kcWR4aOe/keWwz/q0I/fFQIQWz9Z9F97+4Ly1iF9f
         gQ1kNE04Q7k7jPdK8FxTXpRP/DOKYJkG+aDFv407bZa4Qf5ha1kbJbmAfuOhDISg5FCe
         baGkZUDHqMcyRMuBr4mYga31mWpP7byuNqmmIpaqB9Ik91cWh79kV+xlGd1Ip9BIHAmj
         Pja9uMDzQoIUNTlQXFPrq0h5N077sgyq2B7m3MmUAK8QpO+uXsmxSdSmZPU4PmECTNGK
         WGkg==
X-Gm-Message-State: APjAAAXvo7Pdu0IW1Tr+RGUcZj1+8u/3ZxBKwfenPznUCbM1LgBl25ks
        afxoa/fwTnw5390hN1cRXBk=
X-Google-Smtp-Source: APXvYqxIhxXcaBjEiOcvwiOwcZY5TpTm7qD9JrZ8ismHkMgxf0CIXrV9w9YAiqx8X87i+Re8aqp6pQ==
X-Received: by 2002:a17:90a:c68f:: with SMTP id n15mr14700507pjt.20.1573760289509;
        Thu, 14 Nov 2019 11:38:09 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id y24sm8658470pfr.116.2019.11.14.11.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 11:38:08 -0800 (PST)
Date:   Thu, 14 Nov 2019 11:38:06 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        David Miller <davem@davemloft.net>,
        Brandon Streiff <brandon.streiff@ni.com>,
        "Hall, Christopher S" <christopher.s.hall@intel.com>,
        Eugenia Emantayev <eugenia@mellanox.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Feras Daoud <ferasda@mellanox.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Stefan Sorensen <stefan.sorensen@spectralink.com>
Subject: Re: [PATCH net 01/13] ptp: Validate requests to enable time stamping
 of external signals.
Message-ID: <20191114193806.GA19147@localhost>
References: <20191114184507.18937-2-richardcochran@gmail.com>
 <02874ECE860811409154E81DA85FBB589698F67E@ORSMSX121.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02874ECE860811409154E81DA85FBB589698F67E@ORSMSX121.amr.corp.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 07:06:58PM +0000, Keller, Jacob E wrote:
> Just to confirm, these new ioctls haven't been around long enough to be concerned about this change?

The "2" ioctls are about to appear in v5.4, and so I want to get the
flag checking in before the release if possible.

Thanks,
Richard

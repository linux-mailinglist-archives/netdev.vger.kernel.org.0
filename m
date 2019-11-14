Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75FE1FCEDE
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 20:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfKNToO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 14:44:14 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37562 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfKNToO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 14:44:14 -0500
Received: by mail-pg1-f195.google.com with SMTP id z24so4454506pgu.4
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 11:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UxYG/57iLMubn4LlBk0ulBcjGkBpjy3pbOE++zvxyCE=;
        b=bJo9nwA7XsibXpq5PpAEGuqDiMN0jBhRKe/YuEkMUTHklAwG/y2q6Y8Ag47kMxSBc8
         e5qhXTHv+ixsbJi4hZhuX7DYn9UU98ddfBHcIbS8Xp4iGS61CZO1sBUESI+8Ngukr5wu
         m/hpnzkd1x/DqVi1HffLsCt4UduJxjHbk2OUGPV1QY/9e+q2zces6wXyBkpzYQqj4sfI
         LBjKy9KULjVFX0/4WmGzNlJO5xKnC/gaqyt9UEIE2BZNlb7QxC1VpUshyEcSM4K8VA09
         9w+wF+9xFH4g1pyvTcrWF/L66ZtMiCAi/b3Weurv7dtdpM+lz6p3OX13dcMeSARqozD4
         ORgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UxYG/57iLMubn4LlBk0ulBcjGkBpjy3pbOE++zvxyCE=;
        b=U2hmlZTQZRA7CTX1UH8RamaP06Km/PahdhzpheMLKZsY4FX6uknINrY3Ft9RQRYAT6
         gKCm+8VUGq95C19juNJmaMOzwizYjy38AIRsonZKkfQBpJV0Fl9Pi2boXpWi6gCJiw/D
         +xu2UH5s9Jy4nESLOnbm2vIXBJmewa96rrCka7fCGdo/TjaEaVTJS/RiZIcWGx+8+Nkd
         63R3JPEfN2fXDMMAcd9kMBuwrYpMg8+BsXymZxRI6m51JJ75qWLsi805h9/POg4ZnTMK
         T9OaoeDWaH8p4cI/UL7jjzk04eO6Hh3I9gX8IQfZTEMw9wht/baGv99CmwdrFSTXEXcc
         MdKw==
X-Gm-Message-State: APjAAAWl+I49BMu0Mt5rCY5kO1RuG6+61xdMwkAzNzTksNx60bWNJvOX
        CrUyTWC/IwKQQNDQq+ZbQE4R7AbZ
X-Google-Smtp-Source: APXvYqyEsxYpA+m+I8aTKPYj5UzvtdQ6xrIVfGQT4GM3i0GZn6NUeDs123URgqKMFnZQMyrWVHMWhQ==
X-Received: by 2002:a63:1e0d:: with SMTP id e13mr2962265pge.166.1573760653295;
        Thu, 14 Nov 2019 11:44:13 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id u7sm7269675pfh.84.2019.11.14.11.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 11:44:12 -0800 (PST)
Date:   Thu, 14 Nov 2019 11:44:10 -0800
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
Subject: Re: [PATCH net 08/13] ptp: Introduce strict checking of external
 time stamp options.
Message-ID: <20191114194410.GB19147@localhost>
References: <20191114184507.18937-9-richardcochran@gmail.com>
 <02874ECE860811409154E81DA85FBB589698F6E0@ORSMSX121.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02874ECE860811409154E81DA85FBB589698F6E0@ORSMSX121.amr.corp.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 07:12:38PM +0000, Keller, Jacob E wrote:
> So, this patch adds the flag *and* modifies the drivers to accept it, but not actually enable strict checking?
> 
> I'd prefer if this flag got added, and the drivers were modified in separate patches to both allow the flag and to perform the strict check.. that feels like a cleaner patch boundary.
> 
> That would ofcourse break the drivers that reject the strict command until they're fixed in follow-on commands.. hmm

You are right, but if anything I'd squash the following four driver
patches into this one.  I left the series in little steps just to make
review easier.  Strictly speaking, if you were to do a git bisect from
the introduction of the "2" ioctls until here, you would find drivers'
acceptance of the new flags changing.  But it is too late to fix that,
and I doubt anyone will care.

IMHO it *is* important to have v5.4 with strict checking.

Thanks,
Richard

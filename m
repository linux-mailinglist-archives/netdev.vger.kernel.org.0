Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E23F19398D
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 08:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgCZHYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 03:24:13 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:36036 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgCZHYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 03:24:13 -0400
Received: by mail-wr1-f47.google.com with SMTP id 31so6436947wrs.3
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 00:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hCFQK5DNppq30rj3jXPp9d8oZ0RZltIzU2EBPBCPmr4=;
        b=x46sM7sHqmKlfXT6fK310m9AIWg3/drrhth5M+oYVnCkYx//DFlAwpAp8bo+/KgZKu
         Bh+TdGrrsV65pTlt/eDZdcSXGvCMQSi39fbSa78Q+mnTmUcH3fzF1vDNcAZQNFVWG8rl
         DmpAmDNQxiyLKwP5nyLC3/YyHKD63yU87ZV8co9VdBVZjflqdpLEEF5JjaGtLWsbJFKZ
         O5AEXunAdrpI+ZGO+FwvEMhthyCR0A/gQm6rL0XYE098zyZbJZb96I+plLSS6MBZ9MNz
         mXCljadMK7oYtkzmAY/7H9hrPNSrzuOiKKMYKzNyGQ8XIjzN2d1QO97p+wuMO5uYfSQp
         sIXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hCFQK5DNppq30rj3jXPp9d8oZ0RZltIzU2EBPBCPmr4=;
        b=WHcaF3FCsksGS9l/Z5WrKUbgDIufwr2m2BNmj94tffuqPQBfk3VdN5w57Xixwgrt4j
         J50NNPWLT8JigJNx/Z5pHOTo716TtoT9kK+BiS91fv57VnpCKp5OddAwXBqcvCyvmjIi
         gkLvgzQGjmq7Y4UCVHXJKKWP/6MXIrO58qnDgMsb+V/XOJtty3Eije5E2W+qK7bGKISU
         2zJ9aaiOqG2ETy4HsDxc6FTEiWzkp8rbmSee/PXUU2YY9VWWc0P7e7pfrvM8gKodwOF3
         xXDxgCamJVBqEC3SzpvkmfELSUOVDNLTGhBc7qj3s6rpoOIixIKKROPKQdJ8/tYC01b8
         Rm5w==
X-Gm-Message-State: ANhLgQ0NNEWhJyUtAWSEFz+7/1toGzGYGF8xV9ofxwDY7T+XsgCLPLz5
        pCgQl8FLh/ZAk9kSnQsWsQfKKg==
X-Google-Smtp-Source: ADFU+vv7ZyxMZQSYozZog1WmUsIlBFlZGVbnSIgOhuRckAKKqtRFOHChNDB22aFqWep31taniODn7w==
X-Received: by 2002:a5d:464a:: with SMTP id j10mr7541343wrs.3.1585207451482;
        Thu, 26 Mar 2020 00:24:11 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id e9sm2537004wrw.30.2020.03.26.00.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 00:24:11 -0700 (PDT)
Date:   Thu, 26 Mar 2020 08:24:10 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next v2 05/11] devlink: use -ENOSPC to indicate no more
 room for snapshots
Message-ID: <20200326072410.GH11304@nanopsycho.orion>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
 <20200326035157.2211090-6-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326035157.2211090-6-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 04:51:51AM CET, jacob.e.keller@intel.com wrote:
>The devlink_region_snapshot_create function returns -ENOMEM when the
>maximum number of snapshots has been reached. This is confusing because
>it is not an issue of being out of memory. Change this to use -ENOSPC instead.
>
>Reported-by: Jiri Pirko <jiri@resnulli.us>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>

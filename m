Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8771CCB9C
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 16:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgEJOqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 10:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728340AbgEJOqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 10:46:02 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93EDAC061A0C
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 07:46:00 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k1so7639728wrx.4
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 07:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dWGXAsDuLTPug3yygA2+lNtdtfLIiPRzjji6Nkb+UFI=;
        b=WnGbKsOd6myfcbYvmxI3kD0BtlR2sTDUo3bexVl6j5QzPdwuYikgz/W1SwWq5U7yoz
         8C+4yJAp+UPt4R3fgGY6Fv0/tJF3ZyL6PNBSwHFqIZ5GzH7DlZnrdXFEbGgpj2+AyR3a
         MP4AvaFZV2bHxDR4yyFn12bxkAVSSfYTf+KgElYk8EVQGFHgl80y4pzFV/WdlznkKdm6
         hhvm8JdbEgwKppBNmhiG8//11C+H9aXwYKwguroG2T+KQKNTTHY9nGwdbuVmv64FCEVA
         5theLWvEhoL224r4TzGm0cwWCkG64tTfSOxbpf0NTJNs02xIZy6WFv1eAypilnFjRpgj
         TvHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dWGXAsDuLTPug3yygA2+lNtdtfLIiPRzjji6Nkb+UFI=;
        b=V43XXwYYSXTI1MC4Tw3X6BwlB92L/3u6xBFhCwhXPQtNZU57/vQeFtOF7nRFMA7Ak6
         8bvH5NbWZspSToahUMG5OWhQXUeRPPIgXv+oSgkWPEC1ZZM9cnTBzHiaoKDNps+1QAG0
         Md3UwwV+17ZcnsuKp2+IW4q+rOr9X49XQJ8xs9Q8IrI0iCQ36Ap8FiLfgghwbeXvGvU8
         KOSQqYC1bBBVv+PoUw2usXsQw4caUOqTvcnxHE7Ju6uy9tJsHMVZnaxnM4KrLyU2AcbO
         8kCicXOkgG1qy9XLvVHhGqiBeAQDzA+y+d4/bgkUCdpMRkumUaUjVo3SHGAoZbhN6D0u
         8fMg==
X-Gm-Message-State: AGi0PuY/wiTlMH5srpIFWBd7q5ZfUErTcBhct6JmQxActCUxGjjCVNKR
        9liYu7nNR0n6AR+8v5L0nRmCxc58emk=
X-Google-Smtp-Source: APiQypL47jhtxeW9nhJnPyCT449Gd2y/Lwjet8bAaDHVXKWbSo6cmbnRlg+1SrRAwac91TdD1tmRUg==
X-Received: by 2002:a5d:6ca7:: with SMTP id a7mr13750125wra.391.1589121958825;
        Sun, 10 May 2020 07:45:58 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id k5sm12436414wrx.16.2020.05.10.07.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 07:45:57 -0700 (PDT)
Date:   Sun, 10 May 2020 16:45:57 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, parav@mellanox.com,
        yuvalav@mellanox.com, jgg@ziepe.ca, saeedm@mellanox.com,
        leon@kernel.org, andrew.gospodarek@broadcom.com,
        michael.chan@broadcom.com, moshe@mellanox.com, ayal@mellanox.com,
        eranbe@mellanox.com, vladbu@mellanox.com, kliteyn@mellanox.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        tariqt@mellanox.com, oss-drivers@netronome.com,
        snelson@pensando.io, drivers@pensando.io, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, grygorii.strashko@ti.com,
        mlxsw@mellanox.com, idosch@mellanox.com, markz@mellanox.com,
        jacob.e.keller@intel.com, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com,
        vikas.gupta@broadcom.com, sridhar.samudrala@intel.com
Subject: Re: [RFC v2] current devlink extension plan for NICs
Message-ID: <20200510144557.GA7568@nanopsycho>
References: <20200501091449.GA25211@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501091449.GA25211@nanopsycho.orion>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello guys.

Anyone has any opinion on the proposal? Or should I take it as a silent
agreement? :)

We would like to go ahead and start sending patchsets.

Thanks!

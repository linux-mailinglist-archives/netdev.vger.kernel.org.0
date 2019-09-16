Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10312B3523
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730216AbfIPHJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:09:47 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53057 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726927AbfIPHJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:09:46 -0400
Received: by mail-wm1-f66.google.com with SMTP id x2so8764102wmj.2
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 00:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hvpFLhqdaCaAF/r11JiP3g8pogElLtVZ3kN8AgCd8Jw=;
        b=11lUCFxp1utTW+ILg2qWeL1auFTkEa+Pv5vcUz/nlwaV83pXtGhmLd3aHASuRKCfIQ
         tyRv58EJhOHkI1juVBU0QAOJi7sLBelcYf7hCIz2yO74MUHdicBfXBIZ3yg1/hJ6/0DX
         EvRb4/orYOrNdMGOaf0CQ9N4cGWDYdgjGi8yMyljVt5HZnACQBP0tqIzB6oxIPrWUAox
         kEO1fzdptjrjcOI0N8g4a8QuDxtHFC3SevA3EWjQZghYyoYPpShxUMk973Lf4yKT3QNV
         xWvvSNcI6BxAKJ/v/cKH9S9vOtlwmd0Y8LeAT3znH4CgIxKR/aUs67MeQEhKyjlXluww
         7W1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hvpFLhqdaCaAF/r11JiP3g8pogElLtVZ3kN8AgCd8Jw=;
        b=FIjaV2+HNo7B5MLTsPEtCZ+lE19Nz/Xzu2nDFJNaQbeppQHrsetXX4PRoV5uppCIKb
         zxtFqPqQWZlOCh/D271rJeUqf8W1T382780QB3LfiBhO8xVw0KwO2lNaGKjr7UFSG4LO
         tuBebIR0UTtMyIZbAy/UgZ1pvT9kOlbsY4Enp0lCEikGsePv33iWZr1QZNbbLQgS6mhB
         +VSICGLdb4nsStsIY6FpVCu219FQM/C2q+AvETVgj142NEVYVKQA6/bN8JIxSXnGIliM
         ZTZp+gmUUGdRGpExGte6+EgsQ/zBS3W5WLPOh6saZEPgYDJAui1FJajHX/sx6XRo5AoM
         PyyQ==
X-Gm-Message-State: APjAAAUN3ozi6CpRF+z22/aDGz8DczhfTw0aHhYGXW09k8sYxhSdC6e5
        oUQ5Ps12cYnUvKj0x3SriWVLIA==
X-Google-Smtp-Source: APXvYqyw20ARMYI1tLNJdWAx7UJX2AlCDS7R1Ge9vSMpGgDkQPosuiNaFxMv1/wltenXBdW3lSDtmA==
X-Received: by 2002:a05:600c:290c:: with SMTP id i12mr8128638wmd.77.1568617784171;
        Mon, 16 Sep 2019 00:09:44 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id x6sm17061562wmf.38.2019.09.16.00.09.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 00:09:43 -0700 (PDT)
Date:   Mon, 16 Sep 2019 09:09:43 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: Re: [patch net-next 00/15] devlink: allow devlink instances to
 change network namespace
Message-ID: <20190916070943.GK2286@nanopsycho.orion>
References: <20190914064608.26799-1-jiri@resnulli.us>
 <20190916.090111.605211597512563157.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916.090111.605211597512563157.davem@davemloft.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Sep 16, 2019 at 09:01:11AM CEST, davem@davemloft.net wrote:
>
>Jiri, this has to wait until the next merge window sorry.

Sure, no worries :)

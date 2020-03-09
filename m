Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F1417E18B
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 14:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbgCINnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 09:43:19 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38070 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbgCINnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 09:43:18 -0400
Received: by mail-wm1-f68.google.com with SMTP id n2so3159320wmc.3
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 06:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w/Y+2iUuUPOLiAFrAjHYQTvEF8EvcNkPsNEQ+M8p5DU=;
        b=oANTFL1TfYMcmriMom6XOzvrcVlvgdq8agt1ni3CU+hWgo3hvbiBPiTDXww3DNRXOP
         tMbh2oJyOM1+LcwKRDZj99a9wNgxwUkBk3GmM5waxNbxuTSAW31jp6MTH432O+9ONhue
         iP/ax519A403b0rJ0jU6F1NjKyDYQmEnyHHj60ippeL6fUlFkuVo7l8jku6mDuxP490K
         RPRYpy2qyUTZBSU0KZF0wq3tf9jKu0nvnDKfEJXB8akzvPC4RmlnbKk9XQwYb3omxFJ1
         hWy2JJl3bxrWlX8ndajFX3DIdh0trTGaQifRATMuoQJvRZfXP/uyWCQmqyMd5RbPr5be
         l3Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w/Y+2iUuUPOLiAFrAjHYQTvEF8EvcNkPsNEQ+M8p5DU=;
        b=nq0Jql2Hgodyfv5QGjoLh3rtcGyOOh6MmCSGfjkhm3vRrp+KUMez5TzJ7PmLEPp0vS
         qORY+ZtWZvYPW8DCFjEt/dEhOEHeapUNNH4eptq1KDkHc9mC9rCxPLIGdrfqVOwA1CBE
         wUlyZWnpzes/2iGJKeB2cNYu4NxwSnPK5rqZUOjMMG5U+L/kPC4LFgDXB7qzDU6SGep0
         RbTSvdwrB7Z+C7Lsw4We3GydhTiRH0P/yvdA6jfL1XidFq/mw88P8NcdbtVPzrNQElSa
         W2q9nOCnWrcKajvtRlhnUVbPWiTn0S3jmdATspNG2g/Jh8E//JWavtpe/lZ0pXVT0ZDP
         193w==
X-Gm-Message-State: ANhLgQ0MYv3wbEuW44hf71JNs9twHjFWjN9AbMkzfEgSaRvllgMzjHGs
        YhmwZv1v8uqnzcUzQyHMaasoFg==
X-Google-Smtp-Source: ADFU+vsyKkD4ak49Hupuk2CN1x8Ud1wM0CQS5zvpOkm6oHv0qSTgfoCoaTrifkrasscoSwh4Jp/VCg==
X-Received: by 2002:a7b:c446:: with SMTP id l6mr19648091wmi.94.1583761397179;
        Mon, 09 Mar 2020 06:43:17 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id t193sm816488wmt.14.2020.03.09.06.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 06:43:16 -0700 (PDT)
Date:   Mon, 9 Mar 2020 14:43:16 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "ecree@solarflare.com" <ecree@solarflare.com>,
        "mlxsw@mellanox.com" <mlxsw@mellanox.com>
Subject: Re: [patch net-next v4 03/10] flow_offload: check for basic action
 hw stats type
Message-ID: <20200309134316.GC13968@nanopsycho.orion>
References: <20200307114020.8664-1-jiri@resnulli.us>
 <20200307114020.8664-4-jiri@resnulli.us>
 <BN8PR12MB3266F1691CDDA4352EFC2684D3FE0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200309120453.GB13968@nanopsycho.orion>
 <BN8PR12MB32667E9CE0F64894A8638BF3D3FE0@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB32667E9CE0F64894A8638BF3D3FE0@BN8PR12MB3266.namprd12.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 09, 2020 at 02:31:40PM CET, Jose.Abreu@synopsys.com wrote:
>From: Jiri Pirko <jiri@resnulli.us>
>Date: Mar/09/2020, 12:04:53 (UTC+00:00)
>
>> How exactly? This should not have any change for the existing users.
>
>The fix is here: https://patchwork.ozlabs.org/patch/1251573/

Ah! in-kernel selftest. Okay. That didn't occur to me. Thanks!


>
>---
>Thanks,
>Jose Miguel Abreu

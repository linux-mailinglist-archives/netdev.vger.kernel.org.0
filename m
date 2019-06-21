Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1DF4ECE5
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 18:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfFUQRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 12:17:48 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39786 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfFUQRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 12:17:48 -0400
Received: by mail-wm1-f68.google.com with SMTP id z23so7186626wma.4
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 09:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0WhGkVvXAmBoYoHlHOUW5I79x+b+d+ygHBfaP4wj7UI=;
        b=NnDQCSBp5dskskWoplKReGI/YNp+762rMHkEdQ9aY2+2xQhAhUax04usUMR5R4kfgm
         z/c7sNf7YlUKOSZ6IZMW46XTD7HiVceDwIXadPQ8Q2U9MUvIJDNqnC8SG9L4ABUKO/s7
         708n7timHqRHoVhyfRbq8nNPvqm/IGpq3lGJJDLbnBgA/FdX6oUhgboM02uetku/Wbdk
         g3VG1d8QsbYbhIJXXvoT9xmqGWx/Q4WcSaOJdB3MkrUj15WjigJGm/FnGt6SFPXtzFPT
         DHtbIOw2SBO058iPhxSSefyVRSWxZhXdtE1LNFQpL7S1w3hIlqiCSrLik4VA9yyiZiPj
         hhjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0WhGkVvXAmBoYoHlHOUW5I79x+b+d+ygHBfaP4wj7UI=;
        b=nie/yM9oW15BexPPCLs7MtzdoMwneeWsNldkC64LwYEaCraKRYOL8R5kKkj4p0dkFr
         H6WibuBNgGkPL6qmVL2wz782/1UTbzDwbmLDRWlA7DaSnc9aagdTamZHqIL73MnW1qNb
         vdztpzXE8MYZe9AGHSMx2DxVNSU7MxCU+DgPZy1SrWueaqNFcgN2wkAk/jbb7P07eEAc
         WrKuND2TrrjRcHN95kc6dic7Eycvf4+W3BdKMZTl7GonMGwhd4yHpFdoRgRsvFngxYJq
         GXQuUIcIBZBot4SAa7LYu8yZofl8qna7IpRpLUtQubAu+JUtOeEDded2sXHcuT4aCtSM
         TZcQ==
X-Gm-Message-State: APjAAAWSBVycM6lHJJDS1Wm+kAJnWQQUf7+kMJZxziNrQ38YDmqJ4i4c
        dn7w6uzLMtzTLtopAHT/JwVCBQ==
X-Google-Smtp-Source: APXvYqyoaENggUaApEIFyy6YSKvFS4yfgT6HccBOLLnp4Rm1TBDYFbVlGaihV+v4zRDahyz/jxnVig==
X-Received: by 2002:a1c:bbc1:: with SMTP id l184mr4580579wmf.111.1561133866028;
        Fri, 21 Jun 2019 09:17:46 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id d4sm6321052wra.38.2019.06.21.09.17.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 09:17:45 -0700 (PDT)
Date:   Fri, 21 Jun 2019 18:17:45 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        cphealy@gmail.com
Subject: Re: [PATCH net-next 08/12] net: cls_api: do not expose tcf_block to
 drivers
Message-ID: <20190621161745.GD2414@nanopsycho.orion>
References: <20190620194917.2298-1-pablo@netfilter.org>
 <20190620194917.2298-9-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620194917.2298-9-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jun 20, 2019 at 09:49:13PM CEST, pablo@netfilter.org wrote:
>Expose the block index which is sufficient to look up for the
>tcf_block_cb object.

This patch is not exposing block index. I guess this is a leftover.



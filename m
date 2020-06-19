Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8D8200028
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 04:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgFSCZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 22:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726517AbgFSCZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 22:25:37 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441E3C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 19:25:36 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a127so3717885pfa.12
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 19:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8iOcZ85YC8HRXuq4McVHvYPPbZmoMehs/R15pg6ga3I=;
        b=TZLrjIAESO/Sd95M0yzF3orA5D63QLS8OjBLRQc8aQ+R4m1r8mo5yip1oJfMYpdseJ
         oqLxRigo24YfHouoQYQoyFboxj8JU57a72C2r7Va2334QTEsKv0O72LRJglaVK2tzLIs
         Xmc9QqK09ZO2gzkLtKibdBvQw7q7uyPZmQW5V6tKQwpufOKUMWarWa6wFGUg22APNYhR
         LARRlT3xFFAa63DXOzoZEKAV4bH3AHLZVaWMmd8Jb8T5nX3HyQzQaGswSH4JvKqgHsOh
         W50unv4q5lI9oPxueuwOE4P5qHCLGCmlVxH2JlYVIb9LBp/ujlKCtUEQx0XQ9ydhbiwr
         BuPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8iOcZ85YC8HRXuq4McVHvYPPbZmoMehs/R15pg6ga3I=;
        b=NfTy2hShrWitLMNo0G96T+ws1rnffUC+x1Bw4e/yHVVmzUHocKMvTbnmYb7tYWkUh9
         OIdHE7FbfmR1nUCbw21M3nQ4o2JX6662HcpqyBrhdMm5Zao09lDjbZo8JV/zgPUBnGCn
         gmidigjIuibajSxEHSMAG+UsraxUUCkUh3dRRD+GKN/ErH0y0Hw9KAfk1h00KFoMvXnc
         b8MQSRb642OOmhNAOISlkivEFe/gw0RQdpaXNkrqxAb0UinhAUTBF1zoN4VNXBrQKGrG
         9nm/R5hKWLcpU9x/5PYUJbWEaJ3zsgpg0fmo6EVBaeWLp5FzqrbzDVKdLQ+njmo0tUEu
         R+vw==
X-Gm-Message-State: AOAM531SjZf33m3fT4h3bpoi1pDwzb9ILW+j235jZoEscrj8ThejgsDA
        z0/D9y0LlphqDkJ7t2DW0ARufkx9ozg=
X-Google-Smtp-Source: ABdhPJwNpXadbkB9szg8+mEy1kKro81qU39iriU7Us/VvgW2pcdgDguN+Gt40C8ojTzOcC3eJBgkdw==
X-Received: by 2002:a63:391:: with SMTP id 139mr1212219pgd.338.1592533534882;
        Thu, 18 Jun 2020 19:25:34 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p14sm3576350pju.7.2020.06.18.19.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 19:25:34 -0700 (PDT)
Date:   Fri, 19 Jun 2020 10:25:24 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     netdev@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        lucien.xin@gmail.com,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2] tc: m_tunnel_key: fix geneve opt output
Message-ID: <20200619022524.GX102436@dhcp-12-153.nay.redhat.com>
References: <20200618104420.499155-1-liuhangbin@gmail.com>
 <20200618105107.GB27897@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618105107.GB27897@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 12:51:08PM +0200, Simon Horman wrote:
> On Thu, Jun 18, 2020 at 06:44:20PM +0800, Hangbin Liu wrote:
> > Commit f72c3ad00f3b changed the geneve option output from "geneve_opt"
> > to "geneve_opts", which may break the program compatibility. Reset
> > it back to geneve_opt.
> > 
> > Fixes: f72c3ad00f3b ("tc: m_tunnel_key: add options support for vxlan")
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> Thanks Hangbin.
> 
> I agree that the patch in question did change the name of the option
> as you describe, perhaps inadvertently. But I wonder if perhaps this fix
> is too simple as the patch mentioned also:
> 
> 1. Documents the option as geneve_opts
> 2. Adds vxlan_opts
> 
> So this patch invalidates the documentation and creates asymmetry between
> the VXLAN and Geneve variants of this feature.

Not sure if I understand you comment correctly. This patch only fix the cmd
output(revert to previous output format), The cmd option is not changed. e.g.

# tc actions add action tunnel_key set src_ip 1.1.1.1 dst_ip 2.2.2.2 id 42 \
     dst_port 6081 geneve_opts 0102:80:00880022 index 1
# tc actions get action tunnel_key index 1
total acts 0

        action order 1: tunnel_key  set
        src_ip 1.1.1.1
        dst_ip 2.2.2.2
        key_id 42
        dst_port 6081
        geneve_opt 0102:80:00880022
        csum pipe
         index 1 ref 1 bind 0

But this do make a asymmetry for vxlan and geneve output. I prefer
to let them consistent personally. Also it looks more reasonable
to output "geneve_opts" when we have parameter geneve_opts.

So I'm not going to fix it in iproute, but do as Davide mentioned, make
tdc test case accept both 'geneve_opts' and 'geneve_opt'.

Thanks
Hangbin

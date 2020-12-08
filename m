Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7CE2D30BB
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 18:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730682AbgLHRN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 12:13:28 -0500
Received: from www62.your-server.de ([213.133.104.62]:54104 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730469AbgLHRN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 12:13:27 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kmgXd-000EBd-AZ; Tue, 08 Dec 2020 18:12:45 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kmgXd-0009EJ-4s; Tue, 08 Dec 2020 18:12:45 +0100
Subject: Re: [PATCH v2 1/1] xdp: avoid calling kfree twice
To:     Zhu Yanjun <yanjun.zhu@intel.com>, zyjzyj2000@gmail.com,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com
References: <20201209050315.5864-1-yanjun.zhu@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f68c2d75-4a51-445d-cecf-894b65cb8d55@iogearbox.net>
Date:   Tue, 8 Dec 2020 18:12:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201209050315.5864-1-yanjun.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26012/Tue Dec  8 15:38:50 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/20 6:03 AM, Zhu Yanjun wrote:
> In the function xdp_umem_pin_pages, if npgs != umem->npgs and
> npgs >= 0, the function xdp_umem_unpin_pages is called. In this
> function, kfree is called to handle umem->pgs, and then in the
> function xdp_umem_pin_pages, kfree is called again to handle
> umem->pgs. Eventually, umem->pgs is freed twice.
> 
> Acked-by: Björn Töpel <bjorn.topel@intel.com>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@intel.com>

Please also fix up the commit log according to Bjorn's prior feedback [0].
If it's just a cleanup, it should state so, the commit message right now
makes it sound like an actual double free bug.

   [0] https://lore.kernel.org/netdev/0fef898d-cf5e-ef1b-6c35-c98669e9e0ed@intel.com/

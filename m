Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 436FA8AEAE
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 07:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfHMFYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 01:24:47 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:39199 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbfHMFYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 01:24:46 -0400
Received: from [192.168.178.60] ([109.104.47.130]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MPGiR-1hevT50O45-00PbYR; Tue, 13 Aug 2019 07:23:46 +0200
Subject: Re: [PATCH v2 15/34] staging/vc04_services: convert put_page() to
 put_user_page*()
To:     john.hubbard@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-fbdev@vger.kernel.org, Jan Kara <jack@suse.cz>,
        kvm@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Dave Chinner <david@fromorbit.com>,
        dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
        sparclinux@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        ceph-devel@vger.kernel.org, devel@driverdev.osuosl.org,
        rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org,
        Suniel Mahesh <sunil.m@techveda.org>, x86@kernel.org,
        amd-gfx@lists.freedesktop.org,
        Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Mihaela Muraru <mihaela.muraru21@gmail.com>,
        xen-devel@lists.xenproject.org, devel@lists.orangefs.org,
        linux-media@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
        intel-gfx@lists.freedesktop.org,
        Kishore KP <kishore.p@techveda.org>,
        linux-block@vger.kernel.org,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        linux-rpi-kernel@lists.infradead.org,
        Dan Williams <dan.j.williams@intel.com>,
        Sidong Yang <realwakka@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-nfs@vger.kernel.org,
        Eric Anholt <eric@anholt.net>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
References: <20190804224915.28669-1-jhubbard@nvidia.com>
 <20190804224915.28669-16-jhubbard@nvidia.com>
From:   Stefan Wahren <stefan.wahren@i2se.com>
Message-ID: <f92a9b35-072c-a452-3248-ded047a9ee7e@i2se.com>
Date:   Tue, 13 Aug 2019 07:23:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190804224915.28669-16-jhubbard@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:WLtnGHSdIdsSOgSCw9gLWN/He07a3vhG8P/jw9q/ZsKCLbsJUeS
 5llVNlt7KE/tvHn+5EOmDYYv4pX1cHVWKOXHtrw4HQWAHuCkTohFsgxlEY0fExapDm8vR8t
 zVIsUr/Bms6Kvxj5sCY8IbKiNL01LBum+j6x95pPZHXG9iG9KDUI7QIiVK2/58tc3NB1jnX
 y7VHJG/KIA+fGCfAbINIQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:e2tiG/LoUCE=:MfCllk8c06iYHLUWJWcKAL
 cdQ1fi1ypP4tC6pu8XAt4M+fU5mGlkjM5ziFPw9nAP5+ICbjFLhxsiDLATVpll3xwUgna69cS
 Ev9bpFgmBYRqbHsiOVM335kNgAU19xY/LXN/GzEuigzotpDhc5IdC4FGsNTdqmIYi0Bx4dgCw
 bLM/SrMXG40Mg1UArtxdqWQvHnINj7yK6JacwPswBAo33CV5S5U4U1PS67DpEMKA7dX0oduGb
 5fQtkN1kvCZEg2/ekJnnb+PAR6KRS8Eu0zqK7cwQwWxs+nxHFNvcdfFolT7waPuKj24rhpnjW
 ZntPcErm15w8EJ72vFuARtCUk4Lh4jU+zYNtoDE6B8RJqr/+yxycmwEDucEbNXrujkaPH72RU
 fWCHjlXjsJS29DRMlBs91cqiKMaK/ktbzSpegz+iLEJq/HkDuPh/jiz/b8w2crkMXTYEXfcIb
 WqkuI5hHrAdEh99xa/X99FupD8F6iZ52Pv/g2glNHL9WlKL41btCn/KodqBqy/glIqHZeYzq2
 SXjRol/t4oy36qgSCQmUGiCt1lssYLkBWOzcxjui5lZUL2V9O7wn91tHl7G+DbqjQzgMyVtBP
 60iHHkwkWe3su3M3o+o4m8sWd9OG5XIToU/4cSDhBQohrRIKKqoUbXAyCJH96bxaYdq/zseIf
 oMsHaN/31pBaLs6MtsAa2tu5PRj9qlBX5kso+Y5up4mj5gl7CfIWyGwpM4gPWtVKv1En5k3ZR
 HR/0MJ6spaP8P86u5+VALfxj2aM5bbcj+ZVczoVE2BIVl4lPQEesVoHHwFc=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.08.19 00:48, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
>
> For pages that were retained via get_user_pages*(), release those pages
> via the new put_user_page*() routines, instead of via put_page() or
> release_pages().
>
> This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
> ("mm: introduce put_user_page*(), placeholder versions").
>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> Cc: Eric Anholt <eric@anholt.net>
> Cc: Stefan Wahren <stefan.wahren@i2se.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Mihaela Muraru <mihaela.muraru21@gmail.com>
> Cc: Suniel Mahesh <sunil.m@techveda.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Sidong Yang <realwakka@gmail.com>
> Cc: Kishore KP <kishore.p@techveda.org>
> Cc: linux-rpi-kernel@lists.infradead.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: devel@driverdev.osuosl.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Stefan Wahren <stefan.wahren@i2se.com>

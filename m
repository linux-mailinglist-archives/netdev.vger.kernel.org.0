Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEF3A19DACA
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 18:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403815AbgDCQFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 12:05:42 -0400
Received: from mout.web.de ([212.227.15.14]:39801 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728126AbgDCQFl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Apr 2020 12:05:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1585929929;
        bh=HDcc6kP1+3OFn6wTlRUtQm5jM1TzwiTZN51hQpv/OZo=;
        h=X-UI-Sender-Class:Cc:Subject:To:From:Date;
        b=JTxepLq+bBfqp21IjMFac1+WDmlXgs9ByRPpf5HKu9uB7VeT3++7gYl8/3RdeHJnf
         Fi0wWrZmOeX2vsKao/ee6nt0pMvRHGxR9ndHfFM3ZfLRRVJdRFKyy6nNVNUBN7NCT+
         GmwbWHTyhFA8SPrKTi6CwI+5Gyqi5bdMLkGJ3ZIw=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.3] ([93.135.25.116]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LilMD-1im9Su22Af-00cuT4; Fri, 03
 Apr 2020 18:05:29 +0200
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] mlxsw: spectrum_trap: Fix unintentional integer
 overflow on left shift
To:     Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <6de034cd-d7c3-9352-5b87-27284eea8e34@web.de>
Date:   Fri, 3 Apr 2020 18:05:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:Tiv4hNxLqfkWXFCnn3StHc/M7Bbt1lElOS3M1aHemzU3aeW6fvY
 xdiyL64krOS2s97zBqUEM4xt0hko2kx5MGLQBnZ3U8XuRYFQh4QuXLcBDaywVSmDj8Lwik5
 gA0gwPh7K7RH9aZagPhcFHfJODOp8g69m+kB5pImucN3wzCtMretL+NXRcTSCmmJiMf9g75
 gYLH/Vi8DirF1tAeSxrew==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:jD+ma8nvR1c=:5eUWnKnajMXpeKqPhWxXWA
 2h11Xhgw1WMzvoqdY7fD+8nn6ZfrCLnV0kZ5JZJoKazJ27sSW/7wqaB+xNIYVBwVzBOwH+z71
 l5EdIk7rj9Gh0p4+lHXVzNJneMp+vqK0S3Q1GVlJHVQGlv0uXczVDqHx/0UI13JY5kDRWDGVj
 qxBiqhxJ9/tQSWT4FdamR3vwrWNEZqYi8pFVKz3ucxtZiGSusyc5iBgknC3hPkJ5iWZyBQKro
 nVr6bebCPhtYvzvqx/E98i4uwE33+n/HJIqMHuG2MoiYuf78MOA7rMO7mHiZwY+oEJpy/kGY/
 DV5jKI7ikbm5+oe7NIwWLMifUZJoSJiGWfnLG1MR8y9io7BgmNwZstX4ASMXHSZE/RRJRBp67
 98MdxmoCpPmFdpiURg2Dojv2iA8nJ3zAeh1sSv5Az7oJqP4sHHMC3s0NF8v0917MFhCym6Xcx
 El2CivEjkZnuUbYoh9OJu6hJqVpzIBzrmv/gK79H4CwjH+14gBN34m3PnuCu68Xy5FBHCkAYT
 04OaI/HYpnIJBdt+KfIXClANpy12zgNw3Tv6ASDlSFIkUqJ8bCO4z+JX3xNMGWdtMUGHZ3yel
 6vQSIEK7ED/LkKG2Gka5Ay5PMVxYX02He7JJn0+XwoNOI8h4vGytKGYBdm0AX2SBCFEHcAzSS
 lp4anL97YBp8yP0LEGaKeHGHa1y4196rekhGlgtz4SLk4d4wPdHXuLum3BNRtUuYuNSz3I0VG
 oXYYcMH+Bf/YtvjP1qUQ3ShOl+iIspDxN9Qhr6l76JXz0UKuXDfPfrHik6c3g3amOK/8Tmwej
 oFSawkGT3RW0b/r4Nh1hxzkFycrOnRegraUCNRBNmHJTwmFLCMMLx8qAe2NzMtgdhyXRJuoXi
 M1eDmCNSv/kS2jyI6W0YnBDFKdrQhwhcfV0FS7PfIrE69JhPYYQdc06Uo99tET2Ym0TUBoI8Z
 eq2mx/85S6GHaAMQ0pyV2JxRvCUcFcx4g+eYdJUptzHN0aa+OtgE4PRt6zq04vBw28+niGLEf
 MoyMBZOsT/L256ERYQMCOij7vMjW6N87hq4EzFg/E0Uz55AUegRmc45D7X+30br06jX0dK/cb
 wS45+aSLUKNwkJ4Zl5gZzbEEYDB2LLBeeM6Oupqz/dqyupHfIz26j8f06hF/98buU8CeNwX32
 +lISYAU9ahWhtjAKygLRIqKn4eKz0Z0gQLPgqemjYdOCdJAUa7F03iDRlmmBPfoESfXmvBvv5
 xGvx3O3wB4XILtH6n
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Addresses-Coverity: ("Unintentional integer overflow")

Will a slightly different commit subject be more appropriate
according to such information?

Regards,
Markus

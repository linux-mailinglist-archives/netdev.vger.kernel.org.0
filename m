Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B54A3127F4
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 23:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhBGWqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 17:46:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:51000 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhBGWqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Feb 2021 17:46:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 229C2AD24;
        Sun,  7 Feb 2021 22:45:20 +0000 (UTC)
From:   NeilBrown <neilb@suse.de>
To:     Andrew Morton <akpm@linux-foundation.org>
Date:   Mon, 08 Feb 2021 09:45:09 +1100
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Xin Long <lucien.xin@gmail.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix some seq_file users that were recently broken
In-Reply-To: <20210205143550.58d3530918459eafa918ad0c@linux-foundation.org>
References: <161248518659.21478.2484341937387294998.stgit@noble1>
 <20210205143550.58d3530918459eafa918ad0c@linux-foundation.org>
Message-ID: <87ft27ebuy.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 05 2021, Andrew Morton wrote:

> On Fri, 05 Feb 2021 11:36:30 +1100 NeilBrown <neilb@suse.de> wrote:
>
>> A recent change to seq_file broke some users which were using seq_file
>> in a non-"standard" way ...  though the "standard" isn't documented, so
>> they can be excused.  The result is a possible leak - of memory in one
>> case, of references to a 'transport' in the other.
>>=20
>> These three patches:
>>  1/ document and explain the problem
>>  2/ fix the problem user in x86
>>  3/ fix the problem user in net/sctp
>>=20
>
> 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and
> interface") was August 2018, so I don't think "recent" applies here?

I must be getting old :-(

>
> I didn't look closely, but it appears that the sctp procfs file is
> world-readable.  So we gave unprivileged userspace the ability to leak
> kernel memory?

Not quite that bad.  The x86 problem allows arbitrary memory to be
leaked, but that is in debugfs (as I'm sure you saw) so is root-only.
The sctp one only allows an sctp_transport to be pinned.  That is not
good and would, e.g., prevent the module from being unloaded.  But
unlike a simple memory leak it won't affect anything outside of sctp.

>
> So I'm thinking that we aim for 5.12-rc1 on all three patches with a cc:s=
table?

Thanks for looking after these!

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJCBAEBCAAsFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAmAgbXYOHG5laWxiQHN1
c2UuZGUACgkQOeye3VZigbmRIw/+L3opkKLyG2Hn5LtKCl8TV5atFOVnkNdg4u1/
N7vs18opY/vMHwel8DJX3FKF1nZeiZVan1cUox774eoWmFjni/IGrVU9HjVowJhc
zHqv17t60IuxAWl4YAYu1SEryAgLMtX6OlqJVrjQ1WRpMEqWN14SgJ2qbuQQW3Fp
zuCEaR5/MMmWfHtVxthrlmqrPO4DdULJWd54S+OR9AdBTJ5iTP6GqbiT6E5500am
DMlL9oaymdwILGK339a97BDkvo/GcXiU4I9Netwsn+dhE+iM0A6nfdpR2S+UkbLE
fqIC4ICia5Cdd04cuMQxqjDqKqgWoj6q+j5BisfXu+VryUWPp+IKLJnljJ3HKOo1
8HZ4M4ldc2c2fo0BZy8qLgld2Ky9yWfkWvFxD91fdLoW862hb4QSORaqeuOHCCxy
TFEgOfgEXRS0y1YP1ue1TkvBCMlFlRQ/y4b0b7PKLcZmbQ8gZP/ZLtMcPVxS+uiW
WtqvP8ED9uSbmDgZKWrkId0XN2qd/N2VeDqqaHLEm3AYBYKe6sjNRq/P2XhaJgvg
fwgFf5HWbWRwpgdLtSpFdwobSZJoSfoqWPGfHw9qnldXXbLSuDrEHIFRywNCHODl
SpL40dXvgMrkDtHYK7C9V7xPMCj9Ja0dnSR2KJQOJnWXw4NnHUXbVAf7VP+5MqpD
WJxmMU8=
=Gd5p
-----END PGP SIGNATURE-----
--=-=-=--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FA5274AAD
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 23:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgIVVGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 17:06:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46508 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726614AbgIVVGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 17:06:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600808764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=1vfjADD82P5uJIHD7P8dtexZnxCP9QTz/GPuAMO2zJU=;
        b=VoiOZpxzc4p8jz34YjDOj1xtJjcWxe5TSigr/CyHQxDtUPvC26Ld25HekdQqzbee0+ZPyf
        +zkpyUQwqFQGUYm5TNepyFon8nK32c6iTpsDEyh4ehQqlJM08ko8uMH3yoq3SCifEE2+Vg
        +yPj9FDSmhYLfdydeVGIvRQeqDH13Tw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-8SOGbRIOPTGzuJOpoWaeTA-1; Tue, 22 Sep 2020 17:06:01 -0400
X-MC-Unique: 8SOGbRIOPTGzuJOpoWaeTA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 115DB801FD7;
        Tue, 22 Sep 2020 21:05:59 +0000 (UTC)
Received: from [10.10.115.78] (ovpn-115-78.rdu2.redhat.com [10.10.115.78])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CB5101A918;
        Tue, 22 Sep 2020 21:05:56 +0000 (UTC)
Subject: Re: [RFC][Patch v1 2/3] i40e: limit msix vectors based on
 housekeeping CPUs
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     bhelgaas@google.com, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, mtosatti@redhat.com,
        sassmann@redhat.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        thomas.lendacky@amd.com, jerinj@marvell.com,
        mathias.nyman@intel.com, jiri@nvidia.com
References: <20200909150818.313699-1-nitesh@redhat.com>
 <20200909150818.313699-3-nitesh@redhat.com>
 <20200917112359.00006e10@intel.com> <20200921225834.GA30521@lenoir>
 <65513ee8-4678-1f96-1850-0e13dbf1810c@redhat.com>
 <20200922095440.GA5217@lenoir>
 <1b7fba6f-85c3-50d6-a951-78db1ccfd04a@redhat.com>
 <20200922204400.GC5217@lenoir>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <a1cffa53-5583-be62-133f-90d29d607ebf@redhat.com>
Date:   Tue, 22 Sep 2020 17:05:55 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200922204400.GC5217@lenoir>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nitesh@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tD3nkzgY8o5UBGmlwn9Gu2MaB2OUxAmuQ"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tD3nkzgY8o5UBGmlwn9Gu2MaB2OUxAmuQ
Content-Type: multipart/mixed; boundary="EsIDcmYgvwLgMppkCsrLFdE9m1R2Db3bN"

--EsIDcmYgvwLgMppkCsrLFdE9m1R2Db3bN
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US


On 9/22/20 4:44 PM, Frederic Weisbecker wrote:
> On Tue, Sep 22, 2020 at 09:34:02AM -0400, Nitesh Narayan Lal wrote:
>> On 9/22/20 5:54 AM, Frederic Weisbecker wrote:
>>> But I don't also want to push toward a complicated solution to handle C=
PU hotplug
>>> if there is no actual problem to solve there.
>> Sure, even I am not particularly sure about the hotplug scenarios.
> Surely when isolation is something that will be configurable through
> cpuset, it will become interesting. For now it's probably not worth
> adding hundreds lines of code if nobody steps into such issue yet.
>
> What is probably more worthy for now is some piece of code to consolidate
> the allocation of those MSI vectors on top of the number of housekeeping
> CPUs.

+1

>
> Thanks.
>
--=20
Thanks
Nitesh


--EsIDcmYgvwLgMppkCsrLFdE9m1R2Db3bN--

--tD3nkzgY8o5UBGmlwn9Gu2MaB2OUxAmuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkXcoRVGaqvbHPuAGo4ZA3AYyozkFAl9qZzMACgkQo4ZA3AYy
ozmAJw/9GUQFYZJtQYVin44OxOTftvVskx5YZa7tD/zfOcKjX5MHFbYUgQRWUOKu
cARqcOpid/2EZ7zENQswCSOKzXXqhZhkZ3Pt3IyBR/OSgQJaLyg7FXXaRZ4BM4Nw
GBOWciQ32lU68JI/aCSy3YQ70xeYjl8fkQTOZShG8fRP1HgZohLf0ijDHWkGlpbE
sAAPByVQ+kiya5dp2G6NLULptLmwSAno4wcDIW2Z5/ncpvkkzrY52VSCbHQHJEXC
qOVGL9NFIcx195UegFfue2jeeZnnKeiY12FUtS88cfRFGturCDO6stjcL6+oPSUx
fIUrJhPvaeubz5mlZVOnzUfWjERSeN0x3mP0fWL5U5bpBRGGAlEcnoYKImUL7/nR
3QPMf7MxOhE0xv3+j3UfrJ7Iajmq2OZH+R8bbhzj65CNOH+uig+ecSEUhYAjykMd
BncYhpyUq6/bCS9Jf6FW7P3FFzjhh2LeQxHkODjVCr20rf/GymMZ5Jlkwa/quJHb
h/x221GByPOU/hp708nxsxTSNbBy/gKGEkw+sOXakBAm4M8wzKzXMncEBFTneycd
5efgL2PjsSWnfOcFErsdxZlWOKdQH5oNYyrYqKPiOXIITDPz+UzZFcNvbgbT3A28
r5fKs2u/OhDNlgL3qcspwp0oVIAQr2VGw+u5wzLRb0A5Q4gWKNk=
=gzZg
-----END PGP SIGNATURE-----

--tD3nkzgY8o5UBGmlwn9Gu2MaB2OUxAmuQ--


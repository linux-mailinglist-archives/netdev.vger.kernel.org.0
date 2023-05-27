Return-Path: <netdev+bounces-5916-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D47571353E
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 17:05:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A584D281743
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 15:05:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98E0F134A5;
	Sat, 27 May 2023 15:05:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E76644
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 15:05:46 +0000 (UTC)
Received: from sequoia-grove.ad.secure-endpoints.com (sequoia-grove.ad.secure-endpoints.com [IPv6:2001:470:1f07:f77:70f5:c082:a96a:5685])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A34E3
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 08:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/relaxed;
	d=auristor.com; s=MDaemon; r=y; t=1685199943; x=1685804743;
	i=jaltman@auristor.com; q=dns/txt; h=Message-ID:Date:
	MIME-Version:User-Agent:Subject:Content-Language:To:Cc:
	References:From:Organization:In-Reply-To:Content-Type; bh=OGHV7f
	8FsngynZ1IOn8sEr+4Qm71i/QsjmyDT/W+DW4=; b=ScoZ1OqKHMzHBfI8Qppmkb
	AhnyRB5F8QIBE8YkP7JfkELcdwyT+tUWhjPUp9lx8yVxc5fzWQYdw9QCx5maas5s
	tvHZVDq0nMEjWZvGEVB0nPmP60VP0IOWsTm82Cf6SRCoDgpEKMjgNL3U0NJytbG0
	fvFJi5g0MwpVjNE4JhWjg=
X-MDAV-Result: clean
X-MDAV-Processed: sequoia-grove.ad.secure-endpoints.com, Sat, 27 May 2023 11:05:43 -0400
Received: from [IPV6:2603:7000:73c:9c99:401:2567:fdc3:c2b4] by auristor.com (IPv6:2001:470:1f07:f77:28d9:68fb:855d:c2a5) (MDaemon PRO v23.0.2c) 
	with ESMTPSA id md5001003473520.msg; Sat, 27 May 2023 11:05:42 -0400
X-Spam-Processed: sequoia-grove.ad.secure-endpoints.com, Sat, 27 May 2023 11:05:42 -0400
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 2603:7000:73c:9c99:401:2567:fdc3:c2b4
X-MDHelo: [IPV6:2603:7000:73c:9c99:401:2567:fdc3:c2b4]
X-MDArrival-Date: Sat, 27 May 2023 11:05:42 -0400
X-MDOrigin-Country: US, NA
X-Authenticated-Sender: jaltman@auristor.com
X-Return-Path: prvs=1511ba3f43=jaltman@auristor.com
X-Envelope-From: jaltman@auristor.com
X-MDaemon-Deliver-To: netdev@vger.kernel.org
Message-ID: <813a4b0d-5a56-7bc4-c4de-ba6912169881@auristor.com>
Date: Sat, 27 May 2023 11:05:36 -0400
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.1
Subject: Re: [PATCH] Remove hardcoded static string length
Content-Language: en-US
To: Kenny Ho <y2kenny@gmail.com>, David Laight <David.Laight@aculab.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Marc Dionne <marc.dionne@auristor.com>,
 Kenny Ho <Kenny.Ho@amd.com>, David Howells <dhowells@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230523223944.691076-1-Kenny.Ho@amd.com>
 <01936d68-85d3-4d20-9beb-27ff9f62d826@lunn.ch>
 <CAB9dFdt4-cBFhEqsTXk9suE+Bw-xcpM0n3Q6rFmBaa+8A5uMWQ@mail.gmail.com>
 <c0fda91b-1e98-420f-a18a-16bbed25e98d@lunn.ch>
 <CAOWid-erNGD24Ouf4fAJJBqm69QVoHOpNt0E-G+Wt=nq1W4oBQ@mail.gmail.com>
 <5b1355b8-17f7-49c8-b7b5-3d9ecdb146ce@lunn.ch>
 <CAOWid-dYtkcKuNxoOyf3yqSJ7OtcNjaqJLVX1QhRUhYSOO6vHA@mail.gmail.com>
 <30d65ea9170d4f60bd76ed516541cb46@AcuMS.aculab.com>
 <CAOWid-eEbeeU9mOpwgOatt5rHQhRt+xPrsQ1fsMemVZDdeN=MQ@mail.gmail.com>
 <81d01562a59a4fb49cd4681ebcf2e74a@AcuMS.aculab.com>
 <CAOWid-d=OFn7JS5JvsK9qc7X6HeZgOm5OAd1_g2=_GZgpKRZnA@mail.gmail.com>
From: Jeffrey E Altman <jaltman@auristor.com>
Organization: AuriStor, Inc.
In-Reply-To: <CAOWid-d=OFn7JS5JvsK9qc7X6HeZgOm5OAd1_g2=_GZgpKRZnA@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms030807070607010901010700"
X-MDCFSigsAdded: auristor.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HTML_MESSAGE,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is a cryptographically signed message in MIME format.

--------------ms030807070607010901010700
Content-Type: multipart/alternative;
 boundary="------------RmdMt7nvILt7hLP1oa00UDtC"

--------------RmdMt7nvILt7hLP1oa00UDtC
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/25/2023 11:37 AM, Kenny Ho wrote:
> On Thu, May 25, 2023 at 11:04 AM David Laight<David.Laight@aculab.com>  wrote:
>>> "The standard formulation seems to be: <project> <version> built
>>> <yyyy>-<mm>-<dd>"
>> Which I don't recall the string actually matching?
>> Also the people who like reproducible builds don't like __DATE__.
> That's correct, it was not matching even when it was introduced.  I am
> simply taking that as people caring about the content and not simply
> making rxrpc_version_string == UTS_RELEASE.  The current format is:
>
> "linux-" UTS_RELEASE " AF_RXRPC"
>
> Kenny

The RX_PACKET_TYPE_VERSION query is issued by the "rxdebug <host> <port> 
-version" command which prints the received string to stdout.   It has 
also been used some implementations to record the version of the peer.   
Although it is required that a response to the RX_PACKET_TYPE_VERSION 
query be issued, there is no requirement that the returned string 
contain anything beyond a single NUL octet.

Although it is convenient to be able to remotely identify the version of 
an Rx implementation, there are good reasons why this information should 
not be exposed to an anonymous requester:

 1. Linux AF_RXRPC is part of the kernel.  As such, returning
    UTS_RELEASE identifies to potential attackers the explicit kernel
    version, architecture and perhaps distro.  As this query can be
    issued anonymously, this provides an information disclosure that can
    be used to target known vulnerabilities in the kernel.
 2. The RX_PACKET_TYPE_VERSION reply is larger than the query by the
    number of octets in the version data.  As the query is received via
    udp with no reachability test, it means that the
    RX_PACKET_TYPE_VERSION query/response can be used to perform an 3.3x
    amplification attack: 28 octets in and potentially 93 octets out.

With my security hat on I would suggest that either AF_RXRPC return a 
single NUL octet or the c-string "AF_RXRPC" and nothing more.

Jeffrey Altman


--------------RmdMt7nvILt7hLP1oa00UDtC
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <div class="moz-cite-prefix">On 5/25/2023 11:37 AM, Kenny Ho wrote:<br>
    </div>
    <blockquote type="cite"
cite="mid:CAOWid-d=OFn7JS5JvsK9qc7X6HeZgOm5OAd1_g2=_GZgpKRZnA@mail.gmail.com">
      <pre class="moz-quote-pre" wrap="">On Thu, May 25, 2023 at 11:04 AM David Laight <a class="moz-txt-link-rfc2396E" href="mailto:David.Laight@aculab.com">&lt;David.Laight@aculab.com&gt;</a> wrote:
</pre>
      <blockquote type="cite">
        <blockquote type="cite">
          <pre class="moz-quote-pre" wrap="">"The standard formulation seems to be: &lt;project&gt; &lt;version&gt; built
&lt;yyyy&gt;-&lt;mm&gt;-&lt;dd&gt;"
</pre>
        </blockquote>
        <pre class="moz-quote-pre" wrap="">
Which I don't recall the string actually matching?
Also the people who like reproducible builds don't like __DATE__.
</pre>
      </blockquote>
      <pre class="moz-quote-pre" wrap="">
That's correct, it was not matching even when it was introduced.  I am
simply taking that as people caring about the content and not simply
making rxrpc_version_string == UTS_RELEASE.  The current format is:

"linux-" UTS_RELEASE " AF_RXRPC"

Kenny</pre>
    </blockquote>
    <p>The RX_PACKET_TYPE_VERSION query is issued by the "rxdebug
      &lt;host&gt; &lt;port&gt; -version" command which prints the
      received string to stdout.   It has also been used some
      implementations to record the version of the peer.   Although it
      is required that a response to the RX_PACKET_TYPE_VERSION query be
      issued, there is no requirement that the returned string contain
      anything beyond a single NUL octet.</p>
    <p>Although it is convenient to be able to remotely identify the
      version of an Rx implementation, there are good reasons why this
      information should not be exposed to an anonymous requester:<br>
    </p>
    <ol>
      <li>Linux AF_RXRPC is part of the kernel.  As such, returning
        UTS_RELEASE identifies to potential attackers the explicit
        kernel version, architecture and perhaps distro.  As this query
        can be issued anonymously, this provides an information
        disclosure that can be used to target known vulnerabilities in
        the kernel.</li>
      <li>The RX_PACKET_TYPE_VERSION reply is larger than the query by
        the number of octets in the version data.  As the query is
        received via udp with no reachability test, it means that the
        RX_PACKET_TYPE_VERSION query/response can be used to perform an
        3.3x amplification attack: 28 octets in and potentially 93
        octets out.<br>
      </li>
    </ol>
    <p>With my security hat on I would suggest that either AF_RXRPC
      return a single NUL octet or the c-string "AF_RXRPC" and nothing
      more.</p>
    <p>Jeffrey Altman</p>
    <p><br>
    </p>
  </body>
</html>

--------------RmdMt7nvILt7hLP1oa00UDtC--

--------------ms030807070607010901010700
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
DHEwggXSMIIEuqADAgECAhBAAYJpmi/rPn/F0fJyDlzMMA0GCSqGSIb3DQEBCwUAMDoxCzAJ
BgNVBAYTAlVTMRIwEAYDVQQKEwlJZGVuVHJ1c3QxFzAVBgNVBAMTDlRydXN0SUQgQ0EgQTEz
MB4XDTIyMDgwNDE2MDQ0OFoXDTI1MTAzMTE2MDM0OFowcDEvMC0GCgmSJomT8ixkAQETH0Ew
MTQxMEQwMDAwMDE4MjY5OUEyRkQyMDAwMjMzQ0QxGTAXBgNVBAMTEEplZmZyZXkgRSBBbHRt
YW4xFTATBgNVBAoTDEF1cmlTdG9yIEluYzELMAkGA1UEBhMCVVMwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQCkC7PKBBZnQqDKPtZPMLAy77zo2DPvwtGnd1hNjPvbXrpGxUb3
xHZRtv179LHKAOcsY2jIctzieMxf82OMyhpBziMPsFAG/ukihBMFj3/xEeZVso3K27pSAyyN
fO/wJ0rX7G+ges22Dd7goZul8rPaTJBIxbZDuaykJMGpNq4PQ8VPcnYZx+6b+nJwJJoJ46kI
EEfNh3UKvB/vM0qtxS690iAdgmQIhTl+qfXq4IxWB6b+3NeQxgR6KLU4P7v88/tvJTpxIKkg
9xj89ruzeThyRFd2DSe3vfdnq9+g4qJSHRXyTft6W3Lkp7UWTM4kMqOcc4VSRdufVKBQNXjG
IcnhAgMBAAGjggKcMIICmDAOBgNVHQ8BAf8EBAMCBPAwgYQGCCsGAQUFBwEBBHgwdjAwBggr
BgEFBQcwAYYkaHR0cDovL2NvbW1lcmNpYWwub2NzcC5pZGVudHJ1c3QuY29tMEIGCCsGAQUF
BzAChjZodHRwOi8vdmFsaWRhdGlvbi5pZGVudHJ1c3QuY29tL2NlcnRzL3RydXN0aWRjYWEx
My5wN2MwHwYDVR0jBBgwFoAULbfeG1l+KpguzeHUG+PFEBJe6RQwCQYDVR0TBAIwADCCASsG
A1UdIASCASIwggEeMIIBGgYLYIZIAYb5LwAGAgEwggEJMEoGCCsGAQUFBwIBFj5odHRwczov
L3NlY3VyZS5pZGVudHJ1c3QuY29tL2NlcnRpZmljYXRlcy9wb2xpY3kvdHMvaW5kZXguaHRt
bDCBugYIKwYBBQUHAgIwga0MgapUaGlzIFRydXN0SUQgQ2VydGlmaWNhdGUgaGFzIGJlZW4g
aXNzdWVkIGluIGFjY29yZGFuY2Ugd2l0aCBJZGVuVHJ1c3QncyBUcnVzdElEIENlcnRpZmlj
YXRlIFBvbGljeSBmb3VuZCBhdCBodHRwczovL3NlY3VyZS5pZGVudHJ1c3QuY29tL2NlcnRp
ZmljYXRlcy9wb2xpY3kvdHMvaW5kZXguaHRtbDBFBgNVHR8EPjA8MDqgOKA2hjRodHRwOi8v
dmFsaWRhdGlvbi5pZGVudHJ1c3QuY29tL2NybC90cnVzdGlkY2FhMTMuY3JsMB8GA1UdEQQY
MBaBFGphbHRtYW5AYXVyaXN0b3IuY29tMB0GA1UdDgQWBBQB+nzqgljLocLTsiUn2yWqEc2s
gjAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwDQYJKoZIhvcNAQELBQADggEBAJwV
eycprp8Ox1npiTyfwc5QaVaqtoe8Dcg2JXZc0h4DmYGW2rRLHp8YL43snEV93rPJVk6B2v4c
WLeQfaMrnyNeEuvHx/2CT44cdLtaEk5zyqo3GYJYlLcRVz6EcSGHv1qPXgDT0xB/25etwGYq
utYF4Chkxu4KzIpq90eDMw5ajkexw+8ARQz4N5+d6NRbmMCovd7wTGi8th/BZvz8hgKUiUJo
Qle4wDxrdXdnIhCP7g87InXKefWgZBF4VX21t2+hkc04qrhIJlHrocPG9mRSnnk2WpsY0MXt
a8ivbVKtfpY7uSNDZSKTDi1izEFH5oeQdYRkgIGb319a7FjslV8wggaXMIIEf6ADAgECAhBA
AXA7OrqBjMk8rp4OuNQSMA0GCSqGSIb3DQEBCwUAMEoxCzAJBgNVBAYTAlVTMRIwEAYDVQQK
EwlJZGVuVHJ1c3QxJzAlBgNVBAMTHklkZW5UcnVzdCBDb21tZXJjaWFsIFJvb3QgQ0EgMTAe
Fw0yMDAyMTIyMTA3NDlaFw0zMDAyMTIyMTA3NDlaMDoxCzAJBgNVBAYTAlVTMRIwEAYDVQQK
EwlJZGVuVHJ1c3QxFzAVBgNVBAMTDlRydXN0SUQgQ0EgQTEzMIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEAu6sUO01SDD99PM+QdZkNxKxJNt0NgQE+Zt6ixaNP0JKSjTd+SG5L
wqxBWjnOgI/3dlwgtSNeN77AgSs+rA4bK4GJ75cUZZANUXRKw/et8pf9Qn6iqgB63OdHxBN/
15KbM3HR+PyiHXQoUVIevCKW8nnlWnnZabT1FejOhRRKVUg5HACGOTfnCOONrlxlg+m1Vjgn
o1uNqNuLM/jkD1z6phNZ/G9IfZGI0ppHX5AA/bViWceX248VmefNhSR14ADZJtlAAWOi2un0
3bqrBPHA9nDyXxI8rgWLfUP5rDy8jx2hEItg95+ORF5wfkGUq787HBjspE86CcaduLka/Bk2
VwIDAQABo4IChzCCAoMwEgYDVR0TAQH/BAgwBgEB/wIBADAOBgNVHQ8BAf8EBAMCAYYwgYkG
CCsGAQUFBwEBBH0wezAwBggrBgEFBQcwAYYkaHR0cDovL2NvbW1lcmNpYWwub2NzcC5pZGVu
dHJ1c3QuY29tMEcGCCsGAQUFBzAChjtodHRwOi8vdmFsaWRhdGlvbi5pZGVudHJ1c3QuY29t
L3Jvb3RzL2NvbW1lcmNpYWxyb290Y2ExLnA3YzAfBgNVHSMEGDAWgBTtRBnA0/AGi+6ke75C
5yZUyI42djCCASQGA1UdIASCARswggEXMIIBEwYEVR0gADCCAQkwSgYIKwYBBQUHAgEWPmh0
dHBzOi8vc2VjdXJlLmlkZW50cnVzdC5jb20vY2VydGlmaWNhdGVzL3BvbGljeS90cy9pbmRl
eC5odG1sMIG6BggrBgEFBQcCAjCBrQyBqlRoaXMgVHJ1c3RJRCBDZXJ0aWZpY2F0ZSBoYXMg
YmVlbiBpc3N1ZWQgaW4gYWNjb3JkYW5jZSB3aXRoIElkZW5UcnVzdCdzIFRydXN0SUQgQ2Vy
dGlmaWNhdGUgUG9saWN5IGZvdW5kIGF0IGh0dHBzOi8vc2VjdXJlLmlkZW50cnVzdC5jb20v
Y2VydGlmaWNhdGVzL3BvbGljeS90cy9pbmRleC5odG1sMEoGA1UdHwRDMEEwP6A9oDuGOWh0
dHA6Ly92YWxpZGF0aW9uLmlkZW50cnVzdC5jb20vY3JsL2NvbW1lcmNpYWxyb290Y2ExLmNy
bDAdBgNVHQ4EFgQULbfeG1l+KpguzeHUG+PFEBJe6RQwHQYDVR0lBBYwFAYIKwYBBQUHAwIG
CCsGAQUFBwMEMA0GCSqGSIb3DQEBCwUAA4ICAQB/7BKcygLX6Nl4a03cDHt7TLdPxCzFvDF2
bkVYCFTRX47UfeomF1gBPFDee3H/IPlLRmuTPoNt0qjdpfQzmDWN95jUXLdLPRToNxyaoB5s
0hOhcV6H08u3FHACBif55i0DTDzVSaBv0AZ9h1XeuGx4Fih1Vm3Xxz24GBqqVudvPRLyMJ7u
6hvBqTIKJ53uCs3dyQLZT9DXnp+kJv8y7ZSAY+QVrI/dysT8avtn8d7k7azNBkfnbRq+0e88
QoBnel6u+fpwbd5NLRHywXeH+phbzULCa+bLPRMqJaW2lbhvSWrMHRDy3/d8HvgnLCBFK2s4
Spns4YCN4xVcbqlGWzgolHCKUH39vpcsDo1ymZFrJ8QR6ihIn8FmJ5oKwAnnd/G6ADXFC9bu
db9+532phSAXOZrrecIQn+vtP366PC+aClAPsIIDJDsotS5z4X2JUFsNIuEgXGqhiKE7SuZb
rFG9sdcLprSlJN7TsRDc0W2b9nqwD+rj/5MN0C+eKwha+8ydv0+qzTyxPP90KRgaegGowC4d
UsZyTk2n4Z3MuAHX5nAZL/Vh/SyDj/ajorV44yqZBzQ3ChKhXbfUSwe2xMmygA2Z5DRwMRJn
p/BscizYdNk2WXJMTnH+wVLN8sLEwEtQR4eTLoFmQvrK2AMBS9kW5sBkMzINt/ZbbcZ3F+eA
MDGCAxQwggMQAgEBME4wOjELMAkGA1UEBhMCVVMxEjAQBgNVBAoTCUlkZW5UcnVzdDEXMBUG
A1UEAxMOVHJ1c3RJRCBDQSBBMTMCEEABgmmaL+s+f8XR8nIOXMwwDQYJYIZIAWUDBAIBBQCg
ggGXMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDUyNzE1
MDUzNlowLwYJKoZIhvcNAQkEMSIEIBwt4ZUaz261rYOGRUYThjxy+cSAilyku2eWo6Ls0LMD
MF0GCSsGAQQBgjcQBDFQME4wOjELMAkGA1UEBhMCVVMxEjAQBgNVBAoTCUlkZW5UcnVzdDEX
MBUGA1UEAxMOVHJ1c3RJRCBDQSBBMTMCEEABgmmaL+s+f8XR8nIOXMwwXwYLKoZIhvcNAQkQ
AgsxUKBOMDoxCzAJBgNVBAYTAlVTMRIwEAYDVQQKEwlJZGVuVHJ1c3QxFzAVBgNVBAMTDlRy
dXN0SUQgQ0EgQTEzAhBAAYJpmi/rPn/F0fJyDlzMMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZI
AWUDBAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZI
hvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggEAOrEy
DTafkeFM/5IGuh/QO597YINm/oGXG2+Sza739cn4G3dOSiJ1xN1PKimNt6uG26/NU5huzOC9
8tF6Wmf9vzgPXN7ob1MPDXl+eM+bukAgfRP+JMGdTfgSL8xo0vF2WZ0ae5AU5pA1RNp2/TgH
xvPxdHRuORbw5GBwn2AV6ep0ekmNZJzVIrx4vPVU0ytGWYoCxxYaUIauyuiIbVJ9dbuSR8ut
T6HK0IeNjkA2zB3CfyEyxyRkVwITO+AM/U3UqOtJ/TlOu+YSmkEMlrTMTNfsJZrNFk22mo+7
Ra3CKzuf339/lIkogI4af9z6dBOQcDRRG9rm/C1J1fN0ua75ywAAAAAAAA==
--------------ms030807070607010901010700--



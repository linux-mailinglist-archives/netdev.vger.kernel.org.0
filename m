Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9716E11AB00
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 13:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbfLKMdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 07:33:52 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40038 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729144AbfLKMdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 07:33:51 -0500
Received: by mail-qk1-f194.google.com with SMTP id c17so9531268qkg.7;
        Wed, 11 Dec 2019 04:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+RzjGE34ioPFKzWsut22B1rLKHvMto56A+xUgaCNFjg=;
        b=bBbKqeJZLYm76q7n/t452XRYYksH5QK+LJszBX5svzHhapxkCDPlDHDJsGqtDh5y+r
         dTHrE7O/M0SN2S2DzM0lbfBwekyx9fFRHc1M6kE7qQbj7Jn/e4dlUH2flyqSPXJKnKUd
         8SZ5yx0JxmEkYETE6Ye3FJEWWTmYssdjatarosAMHnx2sKDPJbJggMV88Xfe/sQUe0cs
         sM1yKQWcEQSbjU9E6tZyeDm/9zDsgdtUY0ZzAVJjyssmuA+KrrD0vEnrZjPG+f4IpQ/B
         FVHZlx88ilfPePC/ryvFqtI2ZwsiHbl+6kHisgQkQOWr0cPJQwzVadqVWxTUnWx6Z1EL
         Wadg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+RzjGE34ioPFKzWsut22B1rLKHvMto56A+xUgaCNFjg=;
        b=JPQDikXBlZxIuvkKbuZix4BZWO13PuYdezuIcJdvmw98IyNLHLhJJ9W/oAvwwgRH7Y
         8spPp0ywGeXw9gVQeT3VZDu2NfwzqJf/yifgh3+YGvOuwzpFelA80DY1n+iZ1fNWNNKb
         o+IowLvn4Ed97+0TVC1kqgM5VNRrX+J/+NRhwn/WEgUQg2WHr41MQVzGJDe5TUn6fvEo
         hidHnT6blc9UEOuGU7vkzHSyR4ksMwIJR1l6+mmHk8bnMEi5xJuayqO3nF5wVf+n/Odb
         RlZpuZxvfUrmghx/5iIy9H0bgFqw6EBZTt33k1E8seUp07KQCbXtG9mNLMAmF7nur34B
         hekQ==
X-Gm-Message-State: APjAAAWjjibC5vrjpi1qCODuqtZ/kBWHcnWgPFloZPyU5yfkoyJ6E9xR
        xeKemOsva8UYb6nZJqMPSjbI3qP6koZ0iUnOpJfCi/ikgmPqYA==
X-Google-Smtp-Source: APXvYqxhBuSvNJQhc3BVd8e8MLK3ClON+ISXP88Vd458my9mFbzN6LEELzY9aPpZpU9yUkNFDwdMFSdlC8j+NVRzzxM=
X-Received: by 2002:a37:4146:: with SMTP id o67mr2616135qka.232.1576067627385;
 Wed, 11 Dec 2019 04:33:47 -0800 (PST)
MIME-Version: 1.0
References: <20191211123017.13212-1-bjorn.topel@gmail.com>
In-Reply-To: <20191211123017.13212-1-bjorn.topel@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 11 Dec 2019 13:33:36 +0100
Message-ID: <CAJ+HfNg42ycM+3-FP8VsxcuN2CM83hgtLVBo_KyukrOdO6MQBQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 0/6] Introduce the BPF dispatcher
To:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <thoiland@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Dec 2019 at 13:30, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>=
 wrote:
>
[...]
>
> xdp-perf runs, aliged vs non-aligned jump targets
> -------------------------------------------------
>
> In this test dispatchers of different sizes, with and without jump
> target alignment, were exercised. As outlined above the function
> lookup is performed via binary search. This means that depending on
> the pointer value of the function, it can reside in the upper or lower
> part of the search table. The performed tests were:
>
> 1. aligned, mititations=3Dauto, function entry < other entries
> 2. aligned, mititations=3Dauto, function entry > other entries
> 3. non-aligned, mititations=3Dauto, function entry < other entries
> 4. non-aligned, mititations=3Dauto, function entry > other entries
> 5. aligned, mititations=3Doff, function entry < other entries
> 6. aligned, mititations=3Doff, function entry > other entries
> 7. non-aligned, mititations=3Doff, function entry < other entries
> 8. non-aligned, mititations=3Doff, function entry > other entries
>
> The micro benchmarks showed that alignment of jump target has some
> positive impact.
>
> A reply to this cover letter will contain complete data for all runs.
>

Please find all the output of "xdp-perf runs, aliged vs non-aligned
jump targets" below.

To see the alignment impact, compare
align_opneg_auto.txt/nonalign_opneg_auto.txt and
align_opneg_auto.txt/nonalign_opneg_auto.txt.


Bj=C3=B6rn

align_op1_auto.txt
# aligned jump targets, mitigations=3Dauto, prog->bpf_func < other entries
# column 1: number entries in dispatcher
# column 2: size of dispatcher
# column 3: runtime average 1000000 XDP calls (xdp_perf)
1 18 4
2 50 4
3 98 5
4 130 4
5 162 4
6 210 4
7 258 4
8 290 4
9 322 4
10 354 4
11 402 4
12 450 5
13 482 4
14 530 4
15 562 4
16 594 4
17 642 4
18 674 4
19 706 5
20 738 4
21 786 4
22 834 4
23 882 4
24 930 4
25 962 4
26 994 4
27 1042 4
28 1090 4
29 1122 4
30 1154 4
31 1186 4
32 1218 4
33 1266 5
34 1314 5
35 1346 5
36 1378 5
37 1410 5
38 1442 5
39 1474 5
40 1506 5
41 1554 5
42 1602 5
43 1650 5
44 1698 5
45 1746 5
46 1794 5
47 1842 5
48 1890 5
49 1890 17
align_op1_off.txt
# aligned jump targets, mitigations=3Doff, prog->bpf_func < other entries
# column 1: number entries in dispatcher
# column 2: size of dispatcher
# column 3: runtime average 1000000 XDP calls (xdp_perf)
1 18 4
2 50 4
3 98 4
4 130 4
5 162 4
6 210 4
7 258 4
8 290 4
9 322 4
10 354 4
11 402 4
12 450 4
13 482 4
14 530 4
15 562 4
16 594 4
17 642 4
18 674 4
19 706 4
20 738 4
21 786 4
22 834 4
23 882 4
24 930 4
25 962 4
26 994 4
27 1042 5
28 1090 4
29 1122 4
30 1154 4
31 1186 4
32 1218 4
33 1266 5
34 1314 5
35 1346 5
36 1378 5
37 1410 5
38 1442 5
39 1474 5
40 1506 5
41 1554 5
42 1602 5
43 1650 5
44 1698 5
45 1746 5
46 1794 5
47 1842 5
48 1890 5
49 1890 5
align_opneg_auto.txt
# aligned jump targets, mitigations=3Dauto, prog->bpf_func > other entries
# column 1: number entries in dispatcher
# column 2: size of dispatcher
# column 3: runtime average 1000000 XDP calls (xdp_perf)
1 18 4
2 50 4
3 98 4
4 130 4
5 162 4
6 210 4
7 258 4
8 290 5
9 322 5
10 354 5
11 402 5
12 450 5
13 482 5
14 530 5
15 562 5
16 594 5
17 642 5
18 674 5
19 706 5
20 738 5
21 786 5
22 834 5
23 882 5
24 930 5
25 962 5
26 994 5
27 1042 5
28 1090 5
29 1122 5
30 1154 5
31 1186 5
32 1218 5
33 1266 5
34 1314 5
35 1346 5
36 1378 5
37 1410 6
38 1442 5
39 1474 5
40 1506 5
41 1554 5
42 1602 5
43 1650 5
44 1698 5
45 1746 6
46 1794 5
47 1842 5
48 1890 5
49 1890 17
align_opneg_off.txt
# aligned jump targets, mitigations=3Doff, prog->bpf_func > other entries
# column 1: number entries in dispatcher
# column 2: size of dispatcher
# column 3: runtime average 1000000 XDP calls (xdp_perf)
1 18 4
2 50 4
3 98 4
4 130 4
5 162 4
6 210 4
7 258 4
8 290 5
9 322 5
10 354 5
11 402 5
12 450 5
13 482 5
14 530 5
15 562 5
16 594 5
17 642 5
18 674 5
19 706 5
20 738 5
21 786 5
22 834 5
23 882 5
24 930 5
25 962 5
26 994 5
27 1042 5
28 1090 5
29 1122 5
30 1154 5
31 1186 5
32 1218 5
33 1266 5
34 1314 5
35 1346 5
36 1378 5
37 1410 5
38 1442 5
39 1474 5
40 1506 5
41 1554 5
42 1602 5
43 1650 5
44 1698 5
45 1746 5
46 1794 5
47 1842 5
48 1890 5
49 1890 5
mail.txt
align_op1_auto.txt
# aligned jump targets, mitigations=3Dauto, prog->bpf_func < other entries
# column 1: number entries in dispatcher
# column 2: size of dispatcher
# column 3: runtime average 1000000 XDP calls (xdp_perf)
1 18 4
2 50 4
3 98 5
4 130 4
5 162 4
6 210 4
7 258 4
8 290 4
9 322 4
10 354 4
11 402 4
12 450 5
13 482 4
14 530 4
15 562 4
16 594 4
17 642 4
18 674 4
19 706 5
20 738 4
21 786 4
22 834 4
23 882 4
24 930 4
25 962 4
26 994 4
27 1042 4
28 1090 4
29 1122 4
30 1154 4
31 1186 4
32 1218 4
33 1266 5
34 1314 5
35 1346 5
36 1378 5
37 1410 5
38 1442 5
39 1474 5
40 1506 5
41 1554 5
42 1602 5
43 1650 5
44 1698 5
45 1746 5
46 1794 5
47 1842 5
48 1890 5
49 1890 17
align_op1_off.txt
# aligned jump targets, mitigations=3Doff, prog->bpf_func < other entries
# column 1: number entries in dispatcher
# column 2: size of dispatcher
# column 3: runtime average 1000000 XDP calls (xdp_perf)
1 18 4
2 50 4
3 98 4
4 130 4
5 162 4
6 210 4
7 258 4
8 290 4
9 322 4
10 354 4
11 402 4
12 450 4
13 482 4
14 530 4
15 562 4
16 594 4
17 642 4
18 674 4
19 706 4
20 738 4
21 786 4
22 834 4
23 882 4
24 930 4
25 962 4
26 994 4
27 1042 5
28 1090 4
29 1122 4
30 1154 4
31 1186 4
32 1218 4
33 1266 5
34 1314 5
35 1346 5
36 1378 5
37 1410 5
38 1442 5
39 1474 5
40 1506 5
41 1554 5
42 1602 5
43 1650 5
44 1698 5
45 1746 5
46 1794 5
47 1842 5
48 1890 5
49 1890 5
align_opneg_auto.txt
# aligned jump targets, mitigations=3Dauto, prog->bpf_func > other entries
# column 1: number entries in dispatcher
# column 2: size of dispatcher
# column 3: runtime average 1000000 XDP calls (xdp_perf)
1 18 4
2 50 4
3 98 4
4 130 4
5 162 4
6 210 4
7 258 4
8 290 5
9 322 5
10 354 5
11 402 5
12 450 5
13 482 5
14 530 5
15 562 5
16 594 5
17 642 5
18 674 5
19 706 5
20 738 5
21 786 5
22 834 5
23 882 5
24 930 5
25 962 5
26 994 5
27 1042 5
28 1090 5
29 1122 5
30 1154 5
31 1186 5
32 1218 5
33 1266 5
34 1314 5
35 1346 5
36 1378 5
37 1410 6
38 1442 5
39 1474 5
40 1506 5
41 1554 5
42 1602 5
43 1650 5
44 1698 5
45 1746 6
46 1794 5
47 1842 5
48 1890 5
49 1890 17
align_opneg_off.txt
# aligned jump targets, mitigations=3Doff, prog->bpf_func > other entries
# column 1: number entries in dispatcher
# column 2: size of dispatcher
# column 3: runtime average 1000000 XDP calls (xdp_perf)
1 18 4
2 50 4
3 98 4
4 130 4
5 162 4
6 210 4
7 258 4
8 290 5
9 322 5
10 354 5
11 402 5
12 450 5
13 482 5
14 530 5
15 562 5
16 594 5
17 642 5
18 674 5
19 706 5
20 738 5
21 786 5
22 834 5
23 882 5
24 930 5
25 962 5
26 994 5
27 1042 5
28 1090 5
29 1122 5
30 1154 5
31 1186 5
32 1218 5
33 1266 5
34 1314 5
35 1346 5
36 1378 5
37 1410 5
38 1442 5
39 1474 5
40 1506 5
41 1554 5
42 1602 5
43 1650 5
44 1698 5
45 1746 5
46 1794 5
47 1842 5
48 1890 5
49 1890 5
mail.txt
nonalign_op1_auto.txt
# non-aligned jump targets, mitigations=3Dauto, prog->bpf_func < other entr=
ies
# column 1: number entries in dispatcher
# column 2: size of dispatcher
# column 3: runtime average 1000000 XDP calls (xdp_perf)
1 18 4
2 45 4
3 72 4
4 99 4
5 126 4
6 153 4
7 184 4
8 211 4
9 238 4
10 265 4
11 292 4
12 319 4
13 350 4
14 381 4
15 408 4
16 435 4
17 462 4
18 489 4
19 516 4
20 543 4
21 570 4
22 597 4
23 624 4
24 651 4
25 682 5
26 713 4
27 744 4
28 775 4
29 802 4
30 829 4
31 856 4
32 883 4
33 910 5
34 937 5
35 964 5
36 991 5
37 1018 5
38 1045 5
39 1072 5
40 1099 5
41 1126 5
42 1153 5
43 1180 5
44 1207 5
45 1234 5
46 1261 5
47 1288 5
48 1315 5
49 1346 5
50 1377 5
51 1408 5
52 1439 5
53 1470 5
54 1501 5
55 1532 5
56 1563 5
57 1590 5
58 1617 5
59 1644 5
60 1671 5
61 1698 5
62 1725 5
63 1752 5
64 1779 5
65 1779 17
nonalign_op1_off.txt
# non-aligned jump targets, mitigations=3Doff, prog->bpf_func < other entri=
es
# column 1: number entries in dispatcher
# column 2: size of dispatcher
# column 3: runtime average 1000000 XDP calls (xdp_perf)
1 18 4
2 45 4
3 72 4
4 99 4
5 126 4
6 153 4
7 184 4
8 211 4
9 238 4
10 265 4
11 292 4
12 319 4
13 350 4
14 381 4
15 408 4
16 435 4
17 462 4
18 489 4
19 516 4
20 543 4
21 570 5
22 597 5
23 624 4
24 651 4
25 682 4
26 713 4
27 744 5
28 775 4
29 802 4
30 829 4
31 856 4
32 883 4
33 910 5
34 937 5
35 964 5
36 991 5
37 1018 5
38 1045 5
39 1072 5
40 1099 5
41 1126 5
42 1153 5
43 1180 5
44 1207 5
45 1234 5
46 1261 5
47 1288 5
48 1315 5
49 1346 5
50 1377 5
51 1408 5
52 1439 5
53 1470 5
54 1501 5
55 1532 5
56 1563 5
57 1590 5
58 1617 5
59 1644 5
60 1671 5
61 1698 5
62 1725 5
63 1752 5
64 1779 5
65 1779 5
nonalign_opneg_auto.txt
# non-aligned jump targets, mitigations=3Dauto, prog->bpf_func > other entr=
ies
# column 1: number entries in dispatcher
# column 2: size of dispatcher
# column 3: runtime average 1000000 XDP calls (xdp_perf)
1 18 4
2 45 4
3 72 4
4 99 4
5 126 4
6 153 4
7 184 5
8 211 5
9 238 5
10 265 5
11 292 5
12 319 5
13 350 5
14 381 5
15 408 5
16 435 5
17 462 6
18 489 6
19 516 6
20 543 6
21 570 5
22 597 5
23 624 6
24 651 5
25 682 5
26 713 5
27 744 5
28 775 6
29 802 5
30 829 5
31 856 5
32 883 5
33 910 6
34 937 6
35 964 6
36 991 7
37 1018 5
38 1045 5
39 1072 6
40 1099 6
41 1126 6
42 1153 6
43 1180 6
44 1207 5
45 1234 5
46 1261 6
47 1288 6
48 1315 6
49 1346 6
50 1377 7
51 1408 6
52 1439 6
53 1470 6
54 1501 6
55 1532 5
56 1563 5
57 1590 6
58 1617 6
59 1644 6
60 1671 6
61 1698 6
62 1725 5
63 1752 5
64 1779 6
65 1779 17
nonalign_opneg_off.txt
# non-aligned jump targets, mitigations=3Doff, prog->bpf_func > other entri=
es
# column 1: number entries in dispatcher
# column 2: size of dispatcher
# column 3: runtime average 1000000 XDP calls (xdp_perf)
1 18 4
2 45 4
3 72 4
4 99 4
5 126 4
6 153 4
7 184 4
8 211 5
9 238 5
10 265 5
11 292 5
12 319 5
13 350 5
14 381 5
15 408 5
16 435 5
17 462 6
18 489 6
19 516 6
20 543 6
21 570 6
22 597 6
23 624 5
24 651 5
25 682 5
26 713 5
27 744 6
28 775 6
29 802 5
30 829 5
31 856 5
32 883 5
33 910 6
34 937 6
35 964 6
36 991 6
37 1018 5
38 1045 5
39 1072 6
40 1099 6
41 1126 6
42 1153 5
43 1180 6
44 1207 5
45 1234 5
46 1261 7
47 1288 6
48 1315 6
49 1346 6
50 1377 7
51 1408 7
52 1439 6
53 1470 6
54 1501 6
55 1532 6
56 1563 5
57 1590 6
58 1617 6
59 1644 6
60 1671 6
61 1698 5
62 1725 5
63 1752 5
64 1779 6
65 1779 6
nonalign_op1_auto.txt
# non-aligned jump targets, mitigations=3Dauto, prog->bpf_func < other entr=
ies
# column 1: number entries in dispatcher
# column 2: size of dispatcher
# column 3: runtime average 1000000 XDP calls (xdp_perf)
1 18 4
2 45 4
3 72 4
4 99 4
5 126 4
6 153 4
7 184 4
8 211 4
9 238 4
10 265 4
11 292 4
12 319 4
13 350 4
14 381 4
15 408 4
16 435 4
17 462 4
18 489 4
19 516 4
20 543 4
21 570 4
22 597 4
23 624 4
24 651 4
25 682 5
26 713 4
27 744 4
28 775 4
29 802 4
30 829 4
31 856 4
32 883 4
33 910 5
34 937 5
35 964 5
36 991 5
37 1018 5
38 1045 5
39 1072 5
40 1099 5
41 1126 5
42 1153 5
43 1180 5
44 1207 5
45 1234 5
46 1261 5
47 1288 5
48 1315 5
49 1346 5
50 1377 5
51 1408 5
52 1439 5
53 1470 5
54 1501 5
55 1532 5
56 1563 5
57 1590 5
58 1617 5
59 1644 5
60 1671 5
61 1698 5
62 1725 5
63 1752 5
64 1779 5
65 1779 17
nonalign_op1_off.txt
# non-aligned jump targets, mitigations=3Doff, prog->bpf_func < other entri=
es
# column 1: number entries in dispatcher
# column 2: size of dispatcher
# column 3: runtime average 1000000 XDP calls (xdp_perf)
1 18 4
2 45 4
3 72 4
4 99 4
5 126 4
6 153 4
7 184 4
8 211 4
9 238 4
10 265 4
11 292 4
12 319 4
13 350 4
14 381 4
15 408 4
16 435 4
17 462 4
18 489 4
19 516 4
20 543 4
21 570 5
22 597 5
23 624 4
24 651 4
25 682 4
26 713 4
27 744 5
28 775 4
29 802 4
30 829 4
31 856 4
32 883 4
33 910 5
34 937 5
35 964 5
36 991 5
37 1018 5
38 1045 5
39 1072 5
40 1099 5
41 1126 5
42 1153 5
43 1180 5
44 1207 5
45 1234 5
46 1261 5
47 1288 5
48 1315 5
49 1346 5
50 1377 5
51 1408 5
52 1439 5
53 1470 5
54 1501 5
55 1532 5
56 1563 5
57 1590 5
58 1617 5
59 1644 5
60 1671 5
61 1698 5
62 1725 5
63 1752 5
64 1779 5
65 1779 5
nonalign_opneg_auto.txt
# non-aligned jump targets, mitigations=3Dauto, prog->bpf_func > other entr=
ies
# column 1: number entries in dispatcher
# column 2: size of dispatcher
# column 3: runtime average 1000000 XDP calls (xdp_perf)
1 18 4
2 45 4
3 72 4
4 99 4
5 126 4
6 153 4
7 184 5
8 211 5
9 238 5
10 265 5
11 292 5
12 319 5
13 350 5
14 381 5
15 408 5
16 435 5
17 462 6
18 489 6
19 516 6
20 543 6
21 570 5
22 597 5
23 624 6
24 651 5
25 682 5
26 713 5
27 744 5
28 775 6
29 802 5
30 829 5
31 856 5
32 883 5
33 910 6
34 937 6
35 964 6
36 991 7
37 1018 5
38 1045 5
39 1072 6
40 1099 6
41 1126 6
42 1153 6
43 1180 6
44 1207 5
45 1234 5
46 1261 6
47 1288 6
48 1315 6
49 1346 6
50 1377 7
51 1408 6
52 1439 6
53 1470 6
54 1501 6
55 1532 5
56 1563 5
57 1590 6
58 1617 6
59 1644 6
60 1671 6
61 1698 6
62 1725 5
63 1752 5
64 1779 6
65 1779 17
nonalign_opneg_off.txt
# non-aligned jump targets, mitigations=3Doff, prog->bpf_func > other entri=
es
# column 1: number entries in dispatcher
# column 2: size of dispatcher
# column 3: runtime average 1000000 XDP calls (xdp_perf)
1 18 4
2 45 4
3 72 4
4 99 4
5 126 4
6 153 4
7 184 4
8 211 5
9 238 5
10 265 5
11 292 5
12 319 5
13 350 5
14 381 5
15 408 5
16 435 5
17 462 6
18 489 6
19 516 6
20 543 6
21 570 6
22 597 6
23 624 5
24 651 5
25 682 5
26 713 5
27 744 6
28 775 6
29 802 5
30 829 5
31 856 5
32 883 5
33 910 6
34 937 6
35 964 6
36 991 6
37 1018 5
38 1045 5
39 1072 6
40 1099 6
41 1126 6
42 1153 5
43 1180 6
44 1207 5
45 1234 5
46 1261 7
47 1288 6
48 1315 6
49 1346 6
50 1377 7
51 1408 7
52 1439 6
53 1470 6
54 1501 6
55 1532 6
56 1563 5
57 1590 6
58 1617 6
59 1644 6
60 1671 6
61 1698 5
62 1725 5
63 1752 5
64 1779 6
65 1779 6
